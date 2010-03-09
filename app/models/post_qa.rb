class PostQa < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  
  # Relations
  belongs_to :post_qa_category
  belongs_to :post

  # Tags
  acts_as_taggable

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :with_category, lambda { |c| {:conditions => ["post_qa_category_id = ?", c]} }
  named_scope :recent, {:joins => :post, :conditions => ["(Select Count(*) From comments Where comments.commentable_id = post_qas.post_id And comments.commentable_type = 'Post') = ?", 0], :order => "created_at DESC"}
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :interesting, :conditions => ["(Select Count(*) From favorites Where favorites.post_id = post_qas.post_id) > ?", 10]
  named_scope :top_answer, :conditions => ["(Select Count(*) From comments Where comments.commentable_id = post_qas.post_id And comments.commentable_type = 'Post') > ?", 10]
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["post_qas.id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["post_qas.id > ?", att]} }

  def self.paginated_post_more_like_this(params, post)
    type = params[:type]
    type ||= "answered"
    cond = Caboose::EZ::Condition.new :posts do
      type_name == post.type_name
      condition :post_qas do
        fiz =~ '%faz%'
      end
    end
    posts_like = Post.find(:all, :conditions => cond.to_sql(), :order => "created_at DESC")
    arr_p = []
    if type == "answered"
      posts_like.select {|p| arr_p << p if p.comments.size > 0}
    else
      posts_like.select {|p| arr_p << p if p.comments.size == 0}
    end
    
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end
  
  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(school).find_tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_answered(params, school)
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school
    arr_p = []
    post_as = self.with_school(with_school)
    post_as.select {|p| arr_p << p.post if p.post.comments.size > 0}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_asked(params, school)
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school
    arr_p = []
    post_as = self.with_school(with_school)
    post_as.select {|p| arr_p << p.post if p.post.comments.size == 0}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_interesting(params, school)
    arr_p = []
    post_as = self.with_school(school).interesting
    post_as.select {|p| arr_p << p.post if p.post.favorites.size > 10}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_top_answer(params, school)
    arr_p = []
    post_as = self.with_school(school).top_answer
    post_as.select {|p| arr_p << p.post if p.post.comments.size == 0}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end
  
  def self.related_posts(school)
    posts = []
    post_as = self.with_school(school).random(5)
    post_as.select {|p| posts << p.post}
    posts
  end

  def total_good
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end

  def score
    total = self.total_good + self.total_bad
    (total) == 0 ? 0 : (self.total_good.to_f/(total))*100
  end
end

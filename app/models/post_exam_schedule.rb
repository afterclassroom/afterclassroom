class PostExamSchedule < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  
  # Relations
  belongs_to :post, :dependent => :destroy

  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :recent, {:joins => :post, :order => "created_at DESC"}
  scope :with_type, lambda { |tp| {:conditions => ["post_exam_schedules.type_name = ?", tp]} }
  scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "posts.created_at DESC"}}
  scope :due_date, :conditions => ["post_exam_schedules.due_date > ?", Time.now], :order => "due_date DESC"
  scope :interesting, :conditions => ["(Select Count(*) From favorites Where favorites.favorable_id = post_exam_schedules.post_id And favorable_type = ?) > ?", "Post", 10]
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_exam_schedules.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["post_exam_schedules.id > ?", att], :order => "id ASC"} }

  # Tags
  acts_as_taggable_on :tags
  
  def self.paginated_post_conditions_with_option(params, school, type_sh)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_ts = PostExamSchedule.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_exam_schedule, post|
      post_exam_schedule.type_name == type_sh
      post.department_id == department if department
      post.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > Time.now - over.day
    end

    posts = []
    post_ts.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_more_like_this(params, post_like)
    post_ts = PostExamSchedule.ez_find(:all, :include => [:post]) do |post_exam, post|
      post_exam.type = post_like.post_exam_schedule.type
      post.department_id == post_like.department_id
      post.school_year == post_like.school_year
      post.school_id == post_like.school_id
    end

    posts = []
    post_ts.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_due_date(params, school)
    posts = []
    post_as = self.with_school(school).due_date
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_interesting(params, school)
    posts = []
    post_as = self.with_school(school).interesting
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(@school).tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.related_posts(school, type)
    posts = []
    post_as = self.random(5).with_school(school).with_type(type)
    post_as.select {|p| posts << p.post}
    posts
  end
end

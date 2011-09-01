# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTest < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post, :dependent => :destroy

  # Tags
  acts_as_taggable_on :tags

  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :recent, {:joins => :post, :order => "posts.created_at DESC"}
  scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "posts.created_at DESC"}}
  scope :interesting, :conditions => ["(Select Count(*) From favorites Where favorites.favorable_id = post_tests.post_id And favorable_type = ?) > ?", "Post", 10], :order => "id DESC"
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_tests.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["post_tests.id > ?", att], :order => "id ASC"} }

  def self.paginated_post_conditions_with_option(params, school)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_ts = PostTest.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_test, post|
      post.department_id == department if department
      post.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > over.business_days.before(Time.now)
    end

    posts = []
    post_ts.select {|p| posts << p.post}
    return posts
  end

  def self.paginated_post_more_like_this(params, post_like)
    post_ts = PostTest.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_test, post|
      post.department_id == post_like.department_id
      post.school_year == post_like.school_year
      post.school_id == post_like.school_id
    end

    posts = []
    post_ts.select {|p| posts << p.post}
    return posts
  end

  def self.paginated_post_conditions_with_interesting(params, school)
    posts = []
    post_as = self.with_school(school).interesting
    post_as.select {|p| posts << p.post}
    return posts
  end

  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(school).tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.related_posts(school)
    posts = []
    post_as = self.random(5).with_school(school)
    post_as.select {|p| posts << p.post}
    posts
  end
  
  def self.recent_interesting(school_id)
    
    str_school_condition = ""
    
    if school_id != nil
      str_school_condition = "where p.school_id = #{school_id}"
    end
    objs = Post.find_by_sql("select p.* from posts as p right join (select * from post_tests) as pt on p.id = pt.post_id
inner join
(select a.favorable_id, a.created_at, b.total from favorites as a
right join (
select favorable_id,count(favorable_id) as total from favorites
group by favorable_id
having count(favorable_id)>11
) as b
on a.favorable_id = b.favorable_id
order by a.favorable_id DESC, a.created_at DESC ) as f
on p.id = f.favorable_id 
#{str_school_condition}
group by f.favorable_id 
order by f.created_at DESC")
    
  end
end

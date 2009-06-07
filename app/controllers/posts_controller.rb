# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostsController < ApplicationController
  include Viewable
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy, :delete_comment]
  after_filter :store_location, :only => [:index, :list_favorites]
  # GET /posts
  # GET /posts.xml
  def index
    @type_name = "Assignments"
    @new_post_path = "/posts/new?type_name=#{@type_name}"

    if params[:more_like_this_id]
      post = Post.find_by_id(params[:more_like_this_id])
      @posts = Post.paginated_post_more_like_this(post).paginate :page => params[:page], :per_page => 10
    else
      if params[:search]
        @type_name = params[:search][:type_name]
        @search_name = params[:search][:name]
      end
      @post_category_id = PostCategory.find_by_name(@type_name).id
      school = session[:your_school]
      @posts = Post.paginated_post_conditions_with_search(params, school).paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])
    @post_category_id = @post.post_category_id
    @type_name = @post.post_category.name
    @new_post_path = "/posts/new?type_name=#{@type_name}"
    @comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")
    
    update_views(@post)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def show_dialog
    @post = Post.find(params[:id])
    update_views(@post)
    render :layout => false
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
    @type_name = "Assignments"

    if params[:post_category_id]
      post_category = PostCategory.find(params[:post_category_id])
      @type_name = post_category.name
    else
      if params[:type_name]
        @type_name = params[:type_name]
      end
      post_category = PostCategory.find_by_name(@type_name)
    end
    
    @new_post_path = "/posts/new?type_name=#{@type_name}"
    @post_category_name = post_category.name

    @post_categories = PostCategory.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @post_category_id = @post.post_category_id
    @type_name = @post.post_category.name
    @new_post_path = "/posts/new?type_name=#{@type_name}"
    @post_categories = PostCategory.find(:all)
    @school = @post.school
    @department = @post.department
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.type_name = @post.post_category.name

    if @post.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to my_post_user_url(current_user)
  end
  
  def post_dispatch
    post_category_name = ""
    post_category_id = params[:post_category_id]
    if post_category_id
      post_category = PostCategory.find_by_id(post_category_id)
      post_category_name = post_category.name
      post_category_id = post_category.id
    end
    
    case post_category_name
    when "Education"
      redirect_to :controller => "post_educations", :action => "new"
    when "Tutors"
      redirect_to :controller => "post_tutors", :action => "new"
    when "Books"
      redirect_to :controller => "post_books", :action => "new"
    when "Jobs"
      redirect_to :controller => "post_jobs", :action => "new"
    when "Party"
      redirect_to :controller => "post_parties", :action => "new"
    when "Student Awareness"
      redirect_to :controller => "post_awarenesses", :action => "new"
    when "Housing"
      redirect_to :controller => "post_housings", :action => "new"
    when "Team Up"
      redirect_to :controller => "post_teamups", :action => "new"
    else
      redirect_to :controller => "posts", :action => "new", :post_category_id => post_category_id
    end
  end

  def list_comments
    @type_name = "Assignments"
    @new_post_path = "/posts/new?type_name=#{@type_name}"
    @post = Post.find(params[:post_id])
    @comments = @post.comments.paginate :page => params[:page], :per_page => 5, :order => "created_at DESC"
  end
  
  def create_comment
    post_id = params[:post_id]
    comment = params[:comment]
    if comment && post_id
      obj_comment = Comment.new()
      obj_comment.comment = comment
      obj_comment.user = current_user
      post = Post.find_by_id(params[:post_id])
      post.comments << obj_comment
    end
    @post = Post.find(post_id)
    @comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")
    render :partial => "list_comment", :locals => {:post => @post, :comments => @comments}
  end

  def delete_comment
    post_id = params[:post_id]
    comment_id = params[:comment_id]
    if comment_id && post_id
      current_user.posts.find_by_id(post_id).comments.find(comment_id).destroy
    end

    redirect_to :controller => "posts", :action => "list_comments", :post_id => post_id
  end
 
  def rate
    @post = Post.find(params[:id])
    @post.rate(params[:stars], current_user)
    id = "ajaxful-rating-post-#{@post.id}"
    render :update do |page|
      page.replace_html id, ratings_for(@post, :static, :wrap => false)
      page.insert_html :bottom, id, "Thanks for rating!"
      page.visual_effect :highlight, id
    end
  end

  def list_favorites
    if current_user
      @type_name = "Assignments"
      @new_post_path = "/posts/new?type_name=#{@type_name}"
      @list_favorites = current_user.favorites.find(:all, :conditions => ["date(created_at) = ?", Date.today.to_s], :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    end
  end

  def add_to_favorite
    post_id = params[:post_id]
    favorite = Favorite.find_or_create_by_user_id_and_post_id(current_user.id, post_id)
    favorite.created_at = DateTime.now
    if favorite.save
      @favorites = current_user.favorites.find(:all, :conditions => ["date(created_at) = ?", Date.today.to_s], :order => "created_at DESC", :limit => 10)
      render :partial => "list_favorite", :locals => {:favorites => @favorites}
    end
  end

  def update_views(obj)
    updated = update_view_count(obj)
  end
  
  def download()
    path = params['path']
      #Set the X-Accel-Redirect header with the path relative to the /downloads location in nginx
      response.headers['X-Accel-Redirect'] = path
      #Set the Content-Type header as nginx won't change it and Rails will send text/html
      response.headers['Content-Type'] = 'application/octet-stream'
      #Make sure we don't render anything
      render :nothing => true
  end
  
  protected

  def require_current_user
    @user ||= Post.find(params[:post_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

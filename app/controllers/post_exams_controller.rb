# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostExamsController < ApplicationController
  #before_filter RubyCAS::Filter::GatewayFilter
  #before_filter RubyCAS::Filter, :except => [:index, :show, :search, :interesting, :tag, :quick_post_form]
  #before_filter :cas_user
	before_filter :login_required, :except => [:index, :show, :search, :interesting, :tag, :quick_post_form]
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :interesting, :tag, :quick_post_form]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :new, :edit, :search, :interesting, :tag]
  cache_sweeper :post_sweeper, :only => [:create, :update, :detroy]
  
  # GET /post_exams
  # GET /post_exams.xml
  def index
    @post_results = if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      Rails.cache.fetch("more_like_this_department#{post.department_id}_school_year#{post.school_year}") do
        PostExam.paginated_post_more_like_this(params, post)
      end
    else
      Rails.cache.fetch("index_#{@class_name}_#{@school}_year#{params[:year]}_department#{params[:department]}_over#{params[:over]}") do
        PostExam.paginated_post_conditions_with_option(params, @school)
      end
    end
    @posts = @post_results.paginate({:page => params[:page], :per_page => 10})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def search
    @query = params[:search][:query] if params[:search]
    if params[:search]
      @posts = Post.paginated_post_conditions_with_search(params, @school, @type)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def interesting
    #@post_results = PostExam.paginated_post_conditions_with_interesting(params, @school)
    
    @post_results = PostExam.recent_interesting(@school)
    
    @posts = @post_results.paginate({:page => params[:page], :per_page => 10})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def tag
    @tag_name = params[:tag_name]
    @posts = PostExam.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  # GET /post_exams/1
  # GET /post_exams/1.xml
  def show
    @post_exam = PostExam.find(params[:id])
    @post = @post_exam.post
    update_view_count(@post)
    posts_as = PostExam.with_school(@school)
    as_next = posts_as.nexts(@post_exam.id).last
    as_prev = posts_as.previous(@post_exam.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_exam }
    end
  end
  
  # GET /post_exams/new
  # GET /post_exams/new.xml
  def new
    @post_exam = PostExam.new
    @post = Post.new
    @post_exam.post = @post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_exam }
    end
  end
  
  # GET /post_exams/1/edit
  def edit
    @post_exam = PostExam.find(params[:id])
    @post = @post_exam.post
    @tag_list = @post_exam.tags_from(@post.school).join(", ")
  end
  
  # POST /post_exams
  # POST /post_exams.xml
  def create
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_exam = PostExam.new(params[:post_exam])
    if @school.nil?
			flash[:error] = "Please select school."
		  render :action => "new"
		else
		  if simple_captcha_valid?
		    @post.save
		    sc = School.find(@school)
		    sc.tag(@post_exam, :with => @tag_list, :on => :tags)
		    @post_exam.post = @post
		    if @post_exam.save
		      flash[:notice] = "Your post was successfully created."
		      post_wall(@post_exam)
		      redirect_to post_exam_url(@post_exam)
		    else
		      flash[:error] = "Failed to create a new post."
		      render :action => "new"
		    end
		  else
		    flash[:warning] = "Captcha does not match."
		    render :action => "new"
		  end
		end
  end
  
  # PUT /post_exams/1
  # PUT /post_exams/1.xml
  def update
    @post_exam = PostExam.find(params[:id])
    @post = @post_exam.post
    
    if (@post_exam.update_attributes(params[:post_exam]) && @post_exam.post.update_attributes(params[:post]))
      sc = School.find(@post.school.id)
      sc.tag(@post_exam, :with => params[:tag], :on => :tags)
      redirect_to post_exam_url(@post_exam)
    end
  end
  
  # DELETE /post_exams/1
  # DELETE /post_exams/1.xml
  def destroy
    @post_exam = PostExam.find(params[:id])
    @post_exam.post.favorites.destroy_all
    del_post_wall(@post_exam)
    @post_exam.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  def quick_post_form
    @class_name = "PostExam"
    render :partial => "form_request_exam"
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_exam_path
    @class_name = "PostExam"
    @type = PostCategory.find_by_class_name(@class_name).id
    @query = params[:search][:query] if params[:search]
    @departments = Department.of_school(@school)
    if !fragment_exist? :browser_by_subject
      if @school
        @tags = School.find(@school).owned_tags.where(["taggable_type = ?", @class_name])
      else
        @tags = eval(@class_name).tag_counts
      end
    end
  end
  
  def require_current_user
    post_exam = PostExam.find(params[:id])
    post = post_exam.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user))) || current_user.has_role?(:admin)
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

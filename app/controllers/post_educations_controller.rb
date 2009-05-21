# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostEducationsController < ApplicationController
  include Viewable

  before_filter :login_required, :except => [:index, :show]
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index]
  # GET /post_educations
  # GET /post_educations.xml
  def index
    if params[:more_like_this_id]
      post = Post.find_by_id(params[:more_like_this_id])
      @posts = PostEducation.paginated_post_more_like_this(post).paginate :page => params[:page], :per_page => 10
    else
      if params[:search]
        @search_name = params[:search][:name]
      end
      school = session[:your_school]
      @posts = PostEducation.paginated_post_conditions_with_search(params, school).paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @post_educations }
    end
  end

  # GET /post_educations/1
  # GET /post_educations/1.xml
  def show
    @post_education = PostEducation.find(params[:id])
    @post = @post_education.post
    @post_category_id = @post.post_category_id
    @type_name = @post.post_category.name
    @comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")
    
    update_views(@post_education.post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_education }
    end
  end

  def show_dialog
    @post = Post.find(params[:id])
    update_views(@post)
    render :layout => false
  end

  # GET /post_educations/new
  # GET /post_educations/new.xml
  def new
    @post_education = PostEducation.new
    post = Post.new
    @post_category_id = session[:post_category_id]
    @post_education.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Education"
    @education_categories = EducationCategory.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_education }
    end
  end

  # GET /post_educations/1/edit
  def edit
    @post_education = PostEducation.find(params[:id])
    @post = @post_education.post
    @post_categories = PostCategory.find(:all)
    @education_categories = EducationCategory.find(:all)
    @countries = Country.has_cities
    @school = @post_education.post.school
    @department = @post_education.post.department
  end

  # POST /post_educations
  # POST /post_educations.xml
  def create
    @post_education = PostEducation.new(params[:post_education])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_education.post = post

    if @post_education.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_educations/1
  # PUT /post_educations/1.xml
  def update
    @post_education = PostEducation.find(params[:id])

    if (@post_education.update_attributes(params[:post_education]) && @post_education.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_educations/1
  # DELETE /post_educations/1.xml
  def destroy
    @post_education = PostEducation.find(params[:id])
    @post_education.post.destroy

    redirect_to my_post_user_url(current_user)
  end

  def update_views(obj)
    updated = update_view_count(obj)
  end

  protected

  def require_current_user
    @user ||= PostEducation.find(params[:post_education_id] || params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

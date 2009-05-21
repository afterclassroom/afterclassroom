# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTeamupsController < ApplicationController
  include Viewable
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index]
  # GET /post_teamups
  # GET /post_teamups.xml
  def index
    if params[:more_like_this_id]
      post = Post.find_by_id(params[:more_like_this_id])
      @posts = PostTeamup.paginated_post_more_like_this(post).paginate :page => params[:page], :per_page => 10
    else
      if params[:search]
        @search_name = params[:search][:name]
      end

      school = session[:your_school]
      @posts = PostTeamup.paginated_post_conditions_with_search(params, school).paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @post_teamups }
    end
  end

  # GET /post_teamups/1
  # GET /post_teamups/1.xml
  def show
    @post_teamup = PostTeamup.find(params[:id])
    @post = @post_teamup.post
    @post_category_id = @post.post_category_id
    @type_name = @post.post_category.name
    @comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")
    @time_commitments = {'1' => '1-10 hrs', '2' => '11-20 hrs', '3' => '21-39 hrs', '4' => '40 hrs', '5' => 'Negotiable'}
    update_views(@post_teamup.post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_teamup }
    end
  end

  def show_dialog
    @post = Post.find(params[:id])
    @time_commitments = {'1' => '1-10 hrs', '2' => '11-20 hrs', '3' => '21-39 hrs', '4' => '40 hrs', '5' => 'Negotiable'}
    update_views(@post)
    render :layout => false
  end

  # GET /post_teamups/new
  # GET /post_teamups/new.xml
  def new
    @post_teamup = PostTeamup.new
    post = Post.new
    @post_teamup.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Team Up"
    @teamup_categories = TeamupCategory.find(:all)
    @functional_experiences = FunctionalExperience.find(:all)
    @time_commitments = {'1' => '1-10 hrs', '2' => '11-20 hrs', '3' => '21-39 hrs', '4' => '40 hrs', '5' => 'Negotiable'}
    @compansates = ['Cash', 'Equity', 'Negotiable', 'Other', 'None']
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_teamup }
    end
  end

  # GET /post_teamups/1/edit
  def edit
    @post_teamup = PostTeamup.find(params[:id])
    @post = @post_teamup.post
    @post_categories = PostCategory.find(:all)
    @teamup_categories = TeamupCategory.find(:all)
    @functional_experiences = FunctionalExperience.find(:all)
    @time_commitments = {'1' => '1-10 hrs', '2' => '11-20 hrs', '3' => '21-39 hrs', '4' => '40 hrs', '5' => 'Negotiable'}
    @compansates = ['Cash', 'Equity', 'Negotiable', 'Other', 'None']
    @countries = Country.has_cities
    @school = @post_teamup.post.school
    @department = @post_teamup.post.department
    @expected_time_commit = @time_commitments[@post_teamup.expected_time_commit]
  end

  # POST /post_teamups
  # POST /post_teamups.xml
  def create
    @post_teamup = PostTeamup.new(params[:post_teamup])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_teamup.post = post

    if @post_teamup.save
      redirect_to my_post_user_url(current_user)
    end

  end

  # PUT /post_teamups/1
  # PUT /post_teamups/1.xml
  def update
    @post_teamup = PostTeamup.find(params[:id])

    if (@post_teamup.update_attributes(params[:post_teamup]) && @post_teamup.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_teamups/1
  # DELETE /post_teamups/1.xml
  def destroy
    @post_teamup = PostTeamup.find(params[:id])
    @post_teamup.destroy

    redirect_to my_post_user_url(current_user)
  end

  def update_views(obj)
    updated = update_view_count(obj)
  end

  protected

  def require_current_user
    @user ||= PostTeamup.find(params[:post_teamup_id] || params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

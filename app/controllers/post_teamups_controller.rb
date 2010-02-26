# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTeamupsController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search]
  before_filter :login_required, :except => [:index, :show, :search]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search]
  # GET /post_teamups
  # GET /post_teamups.xml
  def index

    if params[:teamType].to_s == "club"#teamup for club
      @clubs = PostTeamup.team_filter(false)
    elsif params[:teamType].to_s == "startup"#team just startup
      @clubs = PostTeamup.more_startup
    else #team for sport
      @clubs = PostTeamup.team_filter(true)
    end
    
#    if params[:more_like_this_id]
#      id = params[:more_like_this_id]
#      post = Post.find_by_id(id)
#      @posts = Post.paginated_post_more_like_this(params, post)
#      @clubs = nil
#    else
#      @posts = Post.paginated_post_conditions_with_option(params, @school, @type)
#    end



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
  
  # GET /post_teamups/1
  # GET /post_teamups/1.xml
  def show
    @post = Post.find(params[:id])
    @post_teamup = @post.post_teamup
    update_view_count(@post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_teamup }
    end
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

  private

  def get_variables
    @new_post_path = new_post_teamup_path
    @type = PostCategory.find_by_name("Team Up").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostTeamup.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

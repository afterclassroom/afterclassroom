# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTutorsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :tag, :effective, :dont_hire]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag, :effective, :dont_hire]
  #before_filter :login_required, :except => [:index, :show, :search, :tag, :effective, :dont_hire]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag, :effective, :dont_hire]
  after_filter :store_go_back_url, :only => [:index, :search, :tag, :effective, :dont_hire]
  # GET /post_tutors
  # GET /post_tutors.xml
  def index
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = Post.paginated_post_more_like_this(params, post)
    else
      @tutor_type_id = params[:tutor_type_id]
      @tutor_type_id ||= TutorType.find(:first).id
      @posts = PostTutor.paginated_post_conditions_with_option(params, @school, @tutor_type_id)
    end
    
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
  
  def tag
    @tag_name = params[:tag_name]
    @posts = PostTutor.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  def effective
    @posts = PostTutor.paginated_post_conditions_with_effective_tutors(params, @school)
  end
  
  def dont_hire
    @posts = PostTutor.paginated_post_conditions_with_dont_hire(params, @school)
  end
  
  def rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    post_tt = @post.post_tutor
    post_tt.rate rating.to_i, current_user
    # Update rating status
    score_good = post_tt.score_good
    score_bad = post_tt.score_bad
    
    if score_good > score_bad
      status = "Good"
    elsif score_good == score_bad
      status = "Require Rating"
    else
      status = "Bad"
    end
    
    post_tt.rating_status = status
    
    post_tt.save
    @text = "<div class='qashdU'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{post_tt.total_good}</a></div>"
    @text << "<div class='qashdD'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{post_tt.total_bad}</a></div>"
  end
  
  def require_rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    @post_tt = post.post_tutor
    if !PostTutor.find_rated_by(current_user).include?(@post_tt)
      @post_tt.rate rating.to_i, current_user
      # Update rating status
      score_good = @post_tt.score_good
      score_bad = @post_tt.score_bad
      
      if score_good > score_bad
        status = "Good"
      elsif score_good == score_bad
        status = "Require Rating"
      else
        status = "Bad"
      end
      
      @post_tt.rating_status = status
      
      @post_tt.save
    end
  end
  
  # GET /post_tutors/1
  # GET /post_tutors/1.xml
  def show
    @post_tt = PostTutor.find(params[:id])
    @post = @post_tt.post
    update_view_count(@post)
    posts_as = PostTutor.with_school(@school)
    as_next = posts_as.next(@post_tt.id).first
    as_prev = posts_as.previous(@post_tt.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_tt }
    end
  end
  
  # GET /post_tutors/new
  # GET /post_tutors/new.xml
  def new
    @post_tutor = PostTutor.new
    @post = Post.new
    @post_tutor.post = @post
    @post_tutor.tutor_type_id = TutorType.find_by_label("request_for_tutor").id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_tutor }
    end
  end
  
  # GET /post_tutors/1/edit
  def edit
    @post_tt = PostTutor.find(params[:id])
    @post = @post_tt.post
    @tag_list = @post_tt.tags_from(@post.school).join(", ")
  end
  
  # POST /post_tutors
  # POST /post_tutors.xml
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post.save
    @post_tutor = PostTutor.new(params[:post_tutor])
    @post.school.tag(@post_tutor, :with => params[:tag], :on => :tags)
    @post.school.owned_taggings
    @post.school.owned_tags
    @post_tutor.post = @post
    @post_tutor.tutor_type_id ||= TutorType.find_by_label("requested_for_tutor").id
    if simple_captcha_valid?
      if @post_tutor.save
        flash.now[:notice] = "Your post was successfully created."
        post_wall(@post, post_tutor_path(@post))
        redirect_to post_tutors_path + "?tutor_type_id=#{@post_tutor.tutor_type_id}"
      else
        flash.now[:error] = "Failed to create a new post."
        render :action => "new"
      end
    else
      flash.now[:warning] = "Captcha not match."
      render :action => "new"
    end
  end
  
  # PUT /post_tutors/1
  # PUT /post_tutors/1.xml
  def update
    @post_tutor = PostTutor.find(params[:id])
    @post = @post_tutor.post
    if (@post_tutor.update_attributes(params[:post_tutor]) && @post_tutor.post.update_attributes(params[:post]))
      @post.school.tag(@post_tutor, :with => params[:tag], :on => :tags)
      redirect_to post_tutor_url(@post_tutor)
    end
    
  end
  
  # DELETE /post_tutors/1
  # DELETE /post_tutors/1.xml
  def destroy
    @post_tutor = PostTutor.find(params[:id])
    @post_tutor.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_tutor_path
    @class_name = "PostTutor"
    @type = PostCategory.find_by_class_name(@class_name).id
    @query = params[:search][:query] if params[:search]
  end
  
  def require_current_user
    post_tutor = PostTutor.find(params[:id])
    post = post_tutor.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

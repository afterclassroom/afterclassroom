# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostQasController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :tag, :asked, :interesting, :top_answer, :prefer]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag, :asked, :interesting, :top_answer, :prefer]
  #before_filter :login_required, :except => [:index, :show, :search, :tag, :asked, :interesting, :top_answer, :create_comment, :prefer]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :new, :edit, :search, :tag, :asked, :interesting, :top_answer, :prefer]
  cache_sweeper :post_sweeper, :only => [:create, :update, :detroy]
  
  # GET /post_qas
  # GET /post_qas.xml
  
  def index
    @type = params[:type]
    @type ||= "answered"
    @post_results = Rails.cache.fetch("index_#{@class_name}_type#{@type}_#{@school}_year(#{params[:year]})_department(#{params[:department]})_over(#{params[:over]})") do
      PostQa.paginated_post_conditions_with_option(params, @school, @type)
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
      format.html # search.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def tag
    @tag_name = params[:tag_name]
    @posts = PostQa.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  def interesting
    @post_results = Rails.cache.fetch("interesting_#{@class_name}_#{@school}") do
      PostQa.paginated_post_conditions_with_interesting(params, @school)
    end
    @posts = @post_results.paginate({:page => params[:page], :per_page => 10})
    respond_to do |format|
      format.html # interesting.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def top_answer
    @posts = PostQa.paginated_post_conditions_with_top_answer(params, @school)
    
    respond_to do |format|
      format.html # top_answer.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    post_q = @post.post_qa
    post_q.rate rating.to_i, current_user
    # Update rating status
    score_good = post_q.score_good
    score_bad = post_q.score_bad
    
    if score_good > score_bad
      status = "Good"
    elsif score_good == score_bad
      status = "Require Rating"
    else
      status = "Bad"
    end
    
    post_q.rating_status = status
    
    post_q.save
    
    @text = "<div class='qashdU'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{post_q.total_good}</a></div>"
    @text << "<div class='qashdD'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{post_q.total_bad}</a></div>"
  end
  
  def require_rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    @post_q = post.post_qa
    if !PostQa.find_rated_by(current_user).include?(@post_q)
      @post_q.rate rating.to_i, current_user
      # Update rating status
      score_good = @post_q.score_good
      score_bad = @post_q.score_bad
      
      if score_good > score_bad
        status = "Good"
      elsif score_good == score_bad
        status = "Require Rating"
      else
        status = "Bad"
      end
      
      @post_q.rating_status = status
      
      @post_q.save
    end
    render :layout => false
  end
  
  # GET /post_qas/1
  # GET /post_qas/1.xml
  def show
    @post_qa = PostQa.find(params[:id])
    @post = @post_qa.post
    @post.comments.size > 0 ? @type = "answered" : @type = "asked"
    update_view_count(@post)
    posts_as = PostQa.with_school(@school).with_type(@type)
    as_next = posts_as.nexts(@post_qa.id).last
    as_prev = posts_as.previous(@post_qa.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_qa }
    end
  end
  
  # GET /post_qas/new
  # GET /post_qas/new.xml
  def new
    @post_qa = PostQa.new
    @post = Post.new
    @post_qa.post = @post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_qa }
    end
  end
  
  # GET /post_qas/1/edit
  def edit
    @post_qa = PostQa.find(params[:id])
    @post = @post_qa.post
    @tag_list = @post_qa.tags_from(@post.school).join(", ")
  end
  
  # POST /post_qas
  # POST /post_qas.xml
  def create
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_qa = PostQa.new(params[:post_qa])
    
    if simple_captcha_valid?   
      @post.save 
      sc = School.find(@school)
      sc.tag(@post_qa, :with => @tag_list, :on => :tags)
      @post_qa.post = @post
      if @post_qa.save
        flash[:notice] = "Your post was successfully created."
        post_wall(@post, post_qa_path(@post_qa))
        redirect_to post_qa_url(@post_qa)
      else
        flash[:error] = "Failed to create a new post."
        render :action => "new"
      end
    else
      flash[:warning] = "Captcha does not match."
      render :action => "new"
    end
  end
  
  # PUT /post_qas/1
  # PUT /post_qas/1.xml
  def update
    @post_qa = PostQa.find(params[:id])
    @post = @post_qa.post
    if (@post_qa.update_attributes(params[:post_qa]) && @post.update_attributes(params[:post]))
      sc = School.find(@post.school.id)
      sc.tag(@post_qa, :with => params[:tag], :on => :tags)
      redirect_to post_qa_url(@post_qa)
    end
  end
  
  # DELETE /post_qas/1
  # DELETE /post_qas/1.xml
  def destroy
    @post_qa = PostQa.find(params[:id])
    @post_qa.post.favorites.destroy_all
    @post_qa.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  def create_comment
    post_id = params[:post_id]
    comment = params[:comment]
    show = params[:show]
    show ||= "0"
    post = Post.find(post_id)
    if comment && post
      obj_comment = Comment.new()
      obj_comment.comment = comment
      obj_comment.user = current_user
      post.comments << obj_comment
    end
    get_comments(post, show)
    render :layout => false
  end
  
  def prefer
    
    @post_id = params[:post_id]
    render :layout => false
  end
  
  def sendmail
    
    QaSendMail.refer_to_expert(params[:strContent], params[:emailAddr],params[:post_id], current_user).deliver
    
    # render :layout => false
    render :text => %Q'Mail sent to'
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_qa_path
    @class_name = "PostQa"
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
    post_qa = PostQa.find(params[:id])
    post = post_qa.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user))) || current_user.has_role?(:admin)
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

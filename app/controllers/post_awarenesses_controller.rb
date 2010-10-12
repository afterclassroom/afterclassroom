# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAwarenessesController < ApplicationController
  include Viewable
  
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag]
  before_filter :login_required, :except => [:index, :show, :search, :tag, :view_results]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag]
  after_filter :store_go_back_url, :only => [:index, :show, :search, :tag]
  # GET /post_awarenesses
  # GET /post_awarenesses.xml
  def index
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = PostAwareness.paginated_post_more_like_this(params, post)
    else
      @awareness_type_id = params[:awareness_type_id]
      @awareness_type_id ||= AwarenessType.find(:first).id
      @posts = PostAwareness.paginated_post_conditions_with_option(params, @school, @awareness_type_id)
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
    tag_id = params[:tag_id]
    @tag = Tag.find(tag_id)
    @posts = PostAwareness.paginated_post_conditions_with_tag(params, @school, @tag.name)
  end

  def rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_a = post.post_awareness
    post_a.rate rating.to_i, current_user
    # Update rating status
    score_good = post_a.score_good
    score_bad = post_a.score_bad

    if score_good > score_bad
      status = "Good"
    elsif score_good == score_bad
      status = "Require Rating"
    else
      status = "Bad"
    end

    post_a.rating_status = status

    post_a.save
    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_a.total_good}</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_a.total_bad}</a>
      </div>
      <script>
        vtip();
      </script>'
  end

  def support
    support = params[:support]
    post = Post.find(params[:post_id])
    post_a = post.post_awareness
    post_a_s = PostAwarenessesSupport.create(:user_id => current_user.id, :post_awareness_id => post_a.id, :support => support)
    str_supported = "You've selected."
    render :text => %Q'
      <div class="support"><a href="javascript:;" class="vtip" title="#{str_supported}">Support</a></div>
      <div class="support"><a href="javascript:;" class="vtip" title="#{str_supported}"> Not support</a></div>
      <script>
        vtip();
      </script>'
  end

  def view_results
    post_awareness_id = params[:post_awareness_id]
    post_awareness = PostAwareness.find(post_awareness_id)
    total_support = post_awareness.total_support.size
    total_notsupport = post_awareness.total_notsupport.size
    chart = GoogleChart.new
    chart.type = :pie
    chart.data = [total_support, total_notsupport]

    #reuse and change size, set labels for big chart
    chart.labels = ['Support','Not support']
    chart.height = 300
    chart.width = 550
    @chart_url = chart.to_url
    render :layout => false
  end

  # GET /post_awarenesses/1
  # GET /post_awarenesses/1.xml
  def show
    @post = Post.find(params[:id])
    @post_awareness = @post.post_awareness
    update_view_count(@post)
    posts_as = PostAwareness.with_school(@school)
    as_next = posts_as.next(@post_awareness.id).first
    as_prev = posts_as.previous(@post_awareness.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_awareness }
    end
  end

  # GET /post_awarenesses/new
  # GET /post_awarenesses/new.xml
  def new
    @post_awareness = PostAwareness.new
    @post = Post.new
    @post_awareness.post = @post
    @post_awareness.awareness_type_id = AwarenessType.first.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_awareness }
    end
  end

  # GET /post_awarenesses/1/edit
  def edit
  end

  # POST /post_awarenesses
  # POST /post_awarenesses.xml
  def create
    @post_awareness = PostAwareness.new(params[:post_awareness])
    post = Post.new(params[:post])
    post.user = current_user
    post.school_id = @school
    post.post_category_id = @type
    post.type_name = @class_name
    post.save
    @post_awareness.tag_list = params[:tag]
    @post_awareness.post = post
    if @post_awareness.save
      notice "Your post was successfully created."
      redirect_to post_awarenesses_path + "?awareness_type_id=#{@post_awareness.awareness_type_id}"
    else
      error "Failed to create a new post."
      render :action => "new"
    end
  end

  # PUT /post_awarenesses/1
  # PUT /post_awarenesses/1.xml
  def update
    params[:post_awareness][:awareness_issue_ids] ||= []
    @post_awareness = PostAwareness.find(params[:id])

    if (@post_awareness.update_attributes(params[:post_awareness]) && @post_awareness.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_awarenesses/1
  # DELETE /post_awarenesses/1.xml
  def destroy
    @post_awareness = PostAwareness.find(params[:id])
    @post_awareness.destroy

    redirect_to my_post_user_url(current_user)
  end

  private

  def get_variables
    @tags = PostAwareness.tag_counts
    @new_post_path = new_post_awareness_path
    @class_name = "PostAwareness"
    @type = PostCategory.find_by_class_name(@class_name).id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    post = Post.find(params[:id])
    @post_awareness = post.post_awareness
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

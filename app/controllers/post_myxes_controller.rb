# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostMyxesController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search, :tag]
  before_filter :login_required, :except => [:index, :show, :search, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag]
  after_filter :update_status, :only => [:create, :update]
  after_filter :store_go_back_url, :only => [:index, :search, :tag]
  
  # GET /post_myxes
  # GET /post_myxes.xml
  def index
    @rating_status = params[:rating_status]
    @rating_status ||= ""
    @posts = PostMyx.paginated_post_conditions_with_option(params, @school, @rating_status)

    @new_myx = PostMyx.new
    post = Post.new
    @new_myx.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Myxes"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_p = post.post_myx
    post_p.rate rating.to_i, current_user
    # Update rating status
    score_good = post_p.score_good
    score_bored = post_p.score_bored
    score_bad = post_p.score_bad

    if score_good == score_bored && score_bored == score_bad
      status = "Require Rating"
    else
      sort_rating_status = {"Good" => score_good, "Bored" => score_bored, "Bad" => score_bad}
      arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
      status = arr_rating_status.last.first
    end

    post_p.rating_status = status

    post_p.save

    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_p.total_good}</a>
      </div>
      <div class="cheap">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">Bored(#{post_p.total_bored})</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_p.total_bad}</a>
      </div>
      <script>
        vtip();
      </script>'
  end

  def require_rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_p = post.post_myx
    if !Postmyx.find_rated_by(current_user).include?(post_p)
      post_p.rate rating.to_i, current_user
      # Update rating status
      score_good = post_p.score_good
      score_bored = post_p.score_bored
      score_bad = post_p.score_bad

      if score_good == score_bored && score_bored == score_bad
        status = "Require Rating"
      else
        sort_rating_status = {"Good" => score_good, "Bored" => score_bored, "Bad" => score_bad}
        arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
        status = arr_rating_status.last.first
      end

      post_p.rating_status = status

      post_p.save
    end

    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;">#{post_p.total_good}</a>
      </div>
      <div class="cheap">
        <a href="javascript:;">Bored(#{post_p.total_bored})</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;">#{post_p.total_bad}</a>
      </div>'
  end

  def tag
    tag_id = params[:tag_id]
    @tag = Tag.find(tag_id)
    @posts = PostMyx.paginated_post_conditions_with_tag(params, @school, @tag.name)
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

  # GET /post_myxes/1
  # GET /post_myxes/1.xml
  def show
    @post = Post.find(params[:id])
    @post_myx = @post.post_myx
    update_view_count(@post)
    posts_as = PostMyx.with_school(@school)
    as_next = posts_as.next(@post_myx.id).first
    as_prev = posts_as.previous(@post_myx.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_myx }
    end
  end

  # GET /post_myxes/new
  # GET /post_myxes/new.xml
  def new
    @post_myx = PostMyx.new
    post = Post.new
    @post_myx.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Myxs"
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_myx }
    end
  end

  # GET /post_myxes/1/edit
  def edit
    @post_myx = PostMyx.find(params[:id])
    @post = @post_myx.post
    @post_categories = PostCategory.find(:all)
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    @school = @post_myx.post.school
    @department = @post_myx.post.department
  end

  # POST /post_myxes
  # POST /post_myxes.xml
  def create
    @post_myx = PostMyx.new(params[:post_myx])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_myx.post = post
    if @post_myx.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_myxes/1
  # PUT /post_myxes/1.xml
  def update
    @post_myx = PostMyx.find(params[:id])

    if (@post_myx.update_attributes(params[:post_myx]) && @post_myx.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_myxes/1
  # DELETE /post_myxes/1.xml
  def destroy
    @post_myx = PostMyx.find(params[:id])
    @post_myx.destroy

    redirect_to my_post_user_url(current_user)
  end
  
  private

  def get_variables
    @tags = PostMyx.tag_counts
    @new_post_path = new_post_myx_path
    @type = PostCategory.find_by_class_name("PostMyx").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostMyx.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end

  def update_status
    if @post_myx.score > 50
      @post_myx.prof_status = "Good"
    else
      @post_myx.prof_status = "Worse"
    end
  end
end

# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostQasController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search, :tag, :asked, :interesting, :top_answer]
  before_filter :login_required, :except => [:index, :show, :search, :tag, :asked, :interesting, :top_answer, :create_comment]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag, :asked, :interesting, :top_answer]
  after_filter :store_go_back_url, :only => [:index, :search, :tag, :asked, :interesting, :top_answer]
  # GET /post_qas
  # GET /post_qas.xml
  def index
    @type = params[:type]
    @type ||= "answered"
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = PostQa.paginated_post_more_like_this(params, post)
    else
      @posts = PostQa.paginated_post_conditions_with_option(params, @school, @type)
    end

    @new_qa = PostQa.new
    post = Post.new
    @new_qa.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "QAs"

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

  def interesting
    @posts = PostQa.paginated_post_conditions_with_interesting(params, @school)

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
    post = Post.find(params[:post_id])
    post_q = post.post_qa
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

    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_q.total_good}</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_q.total_bad}</a>
      </div>
      <script>
        vtip();
      </script>'
  end

  def require_rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_q = post.post_qa
    if !PostQa.find_rated_by(current_user).include?(post_q)
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
    end

    render :text => %Q'
      <div class="QAsDet">Good <strong>(#{post_q.total_good})</strong></div>
      <div class="QAsDet">Bad <strong>(#{post_q.total_bad})</strong></div>'
  end

  # GET /post_qas/1
  # GET /post_qas/1.xml
  def show
    @post = Post.find(params[:id])
    @post_qa = @post.post_qa
    update_view_count(@post)
    posts_as = PostQa.with_school(@school)
    as_next = posts_as.next(@post_qa.id).first
    as_prev = posts_as.previous(@post_qa.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_qa }
    end
  end

  # GET /post_qas/new
  # GET /post_qas/new.xml
  def new
    @post_qa = PostBook.new
    post = Post.new
    @post_qa.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Books"
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_qa }
    end
  end

  # GET /post_qas/1/edit
  def edit
    @post_qa = PostBook.find(params[:id])
    @post = @post_qa.post
    @post_categories = PostCategory.find(:all)
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    @school = @post_qa.post.school
    @department = @post_qa.post.department
  end

  # POST /post_qas
  # POST /post_qas.xml
  def create
    @post_qa = PostBook.new(params[:post_qa])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_qa.post = post
    if @post_qa.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_qas/1
  # PUT /post_qas/1.xml
  def update
    @post_qa = PostBook.find(params[:id])

    if (@post_qa.update_attributes(params[:post_qa]) && @post_qa.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_qas/1
  # DELETE /post_qas/1.xml
  def destroy
    @post_qa = PostBook.find(params[:id])
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

  def show_comment
    show = params[:show]
    show ||= "0"
    post_id = params[:post_id]
    post = Post.find(post_id)
    get_comments(post, show)
  end
  
  private

  def get_variables
    @tags = PostQa.tag_counts
    @new_post_path = new_post_qa_path
    @type = PostCategory.find_by_class_name("PostQa").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def get_comments(post, show)
    @comments = []
    case show
    when "0"
      @comments = post.comments
    when "1"
      @comments = post.comments
    when "2"
      @comments = post.comments.find(:all, :order => "created_at DESC")
    when "3"
      arr_comnt = []
      post.comments.each do |c|
        arr_comnt << {:obj => c, :total_good => c.total_good}
      end
      arr_comnt.sort_by { |c| -c[:total_good] }.each do |d|
        @comments << d[:obj]
      end
    end
  end

  def require_current_user
    @user ||= PostQa.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostBooksController < ApplicationController
  

  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag]
  before_filter :login_required, :except => [:index, :show, :search, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :tag]
  # GET /post_books
  # GET /post_books.xml
  def index
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = Post.paginated_post_more_like_this(params, post)
    else
      @book_type_id = params[:book_type_id]
      @book_type_id ||= BookType.find(:first).id
      @posts = PostBook.paginated_post_conditions_with_option(params, @school, @book_type_id)
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
    @posts = PostBook.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end

  def good_books
    @posts = PostBook.paginated_post_conditions_with_good_books(params, @school)
  end
    
  def dont_buy
    @posts = PostBook.paginated_post_conditions_with_dont_buy(params, @school)
  end

  def rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    post_b = @post.post_book
    post_b.rate rating.to_i, current_user
    # Update rating status
    score_good = post_b.score_good
    score_bad = post_b.score_bad

    if score_good > score_bad
      status = "Good"
    elsif score_good == score_bad
      status = "Require Rating"
    else
      status = "Bad"
    end

    post_b.rating_status = status

    post_b.save

    @text = "<div class='qashdU'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{post_b.total_good}</a></div>"
    @text << "<div class='qashdD'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{post_b.total_bad}</a></div>"
  end

  def require_rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    @post_b = post.post_book
    if !PostBook.find_rated_by(current_user).include?(@post_b)
      @post_b.rate rating.to_i, current_user
      # Update rating status
      score_good = @post_b.score_good
      score_bad = @post_b.score_bad

      if score_good > score_bad
        status = "Good"
      elsif score_good == score_bad
        status = "Require Rating"
      else
        status = "Bad"
      end

      @post_b.rating_status = status

      @post_b.save
    end
=begin
    render :text => %Q'
      <div class="QAsDet">Good <strong>(#{post_b.total_good})</strong></div>
      <div class="QAsDet">Bad <strong>(#{post_b.total_bad})</strong></div>'
=end
    end
  
  # GET /post_books/1
  # GET /post_books/1.xml
  def show
    @post = Post.find(params[:id])
    @post_book = @post.post_book
    update_view_count(@post)
    posts_as = PostBook.with_school(@school)
    as_next = posts_as.next(@post_book.id).first
    as_prev = posts_as.previous(@post_book.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_book }
    end
  end

  # GET /post_books/new
  # GET /post_books/new.xml
  def new
    @post_book = PostBook.new
    @post = Post.new
    @post_book.post = @post
    @post_book.book_type_id = BookType.first.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_book }
    end
  end

  # GET /post_books/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /post_books
  # POST /post_books.xml
  def create
    @post_book = PostBook.new(params[:post_book])
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post.save
    @post_book.tag_list = params[:tag]
    @post_book.post = @post
    @post_book.book_type_id ||= BookType.first.id
    if @post_book.save
      flash.now[:notice] = "Your post was successfully created."
      redirect_to post_books_path + "?book_type_id=#{@post_book.book_type_id}"
    else
      error "Failed to create a new post."
      render :action => "new"
    end
  end

  # PUT /post_books/1
  # PUT /post_books/1.xml
  def update
    @post_book = PostBook.find(params[:id])

    if (@post_book.update_attributes(params[:post_book]) && @post_book.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_books/1
  # DELETE /post_books/1.xml
  def destroy
    @post_book = PostBook.find(params[:id])
    @post_book.destroy

    redirect_to my_post_user_url(current_user)
  end

  private

  def get_variables
    @tags = PostBook.tag_counts_on(:tags)
    @new_post_path = new_post_book_path
    @class_name = "PostBook"
    @type = PostCategory.find_by_class_name(@class_name).id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    post = Post.find(params[:id])
    @post_book = post.post_book
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

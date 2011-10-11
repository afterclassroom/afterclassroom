# -*- coding: utf-8 -*-
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostBooksController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :tag, :good_books, :dont_buy]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag, :good_books, :dont_buy]
  #before_filter :login_required, :except => [:index, :show, :search, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :new, :edit, :search, :tag, :good_books, :dont_buy]
  cache_sweeper :post_sweeper, :only => [:create, :update, :detroy]
  
  # GET /post_books
  # GET /post_books.xml
  def index
    @book_type_id = params[:book_type_id]
    @book_type_id ||= BookType.find(:first).id
    @post_results = Rails.cache.fetch("index_#{@class_name}_type#{@book_type_id}_#{@school}_year#{params[:year]}_department#{params[:department]}_over#{params[:over]}") do
      PostBook.paginated_post_conditions_with_option(params, @school, @book_type_id)
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

  def rate_cmt

    render :text => ""
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
    render :layout => false
  end
  
  # GET /post_books/1
  # GET /post_books/1.xml
  def show
    @post_book = PostBook.find(params[:id])
    @post = @post_book.post
    @book_type_id = @post_book.book_type_id
    update_view_count(@post)
    posts_as = PostBook.with_school(@school).with_type(@book_type_id)
    as_next = posts_as.nexts(@post_book.id).last
    as_prev = posts_as.previous(@post_book.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
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
    @post_book = PostBook.find(params[:id])
    @post = @post_book.post
    @tag_list = @post_book.tags_from(@post.school).join(", ")
  end
  
  # POST /post_books
  # POST /post_books.xml
  def create
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_book = PostBook.new(params[:post_book])
    @post_book.book_type_id ||= BookType.first.id
    
    if simple_captcha_valid?      
      @post.save      
      sc = School.find(@school)
      sc.tag(@post_book, :with => @tag_list, :on => :tags)
      @post_book.post = @post
      if @post_book.save
        flash[:notice] = "Your post was successfully created."
        post_wall(@post_book)
        redirect_to post_book_path(@post_book)
      else
        flash[:error] = "Failed to create a new post."
        render :action => "new"
      end
    else
      flash[:warning] = "Captcha does not match."
      render :action => "new"
    end
  end
  
  # PUT /post_books/1
  # PUT /post_books/1.xml
  def update
    @post_book = PostBook.find(params[:id])
    @post = @post_book.post
    
    if (@post_book.update_attributes(params[:post_book]) && @post_book.post.update_attributes(params[:post]))
      sc = School.find(@post.school.id)
      sc.tag(@post_book, :with => params[:tag], :on => :tags)
      redirect_to post_book_path(@post_book)
    end
  end
  
  # DELETE /post_books/1
  # DELETE /post_books/1.xml
  def destroy
    @post_book = PostBook.find(params[:id])
    @post_book.post.favorites.destroy_all
    del_post_wall(@post_book)
    @post_book.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_book_path
    @class_name = "PostBook"
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
    post_book = PostBook.find(params[:id])
    post = post_book.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user))) || current_user.has_role?(:admin)
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

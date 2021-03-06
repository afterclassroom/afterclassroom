# -*- coding: utf-8 -*-
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostHousingsController < ApplicationController
  #before_filter RubyCAS::Filter::GatewayFilter
  #before_filter RubyCAS::Filter, :except => [:index, :show, :search, :tag, :good_house, :worse_house]
  #before_filter :cas_user
	before_filter :login_required, :except => [:index, :show, :search, :tag, :good_house, :worse_house]
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag, :good_house, :worse_house]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :new, :edit, :search, :tag, :good_house, :worse_house]
  cache_sweeper :post_sweeper, :only => [:create, :update, :detroy]
  
  # GET /post_housings
  # GET /post_housings.xml
  def index
    @housing_category_id = params[:housing_category_id]
    @post_results = Rails.cache.fetch("index_#{@class_name}_category#{@housing_category_id}_#{@school}") do
      PostHousing.paginated_post_conditions_with_option(params, @school, @housing_category_id)
    end
    @posts = @post_results.paginate({:page => params[:page], :per_page => 10})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def good_house
    @posts = PostHousing.paginated_post_conditions_with_good_housing(params, @school)
  end
  
  def worse_house
    @posts = PostHousing.paginated_post_conditions_with_worse_housing(params, @school)
  end
  
  def rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    @post_h = @post.post_housing
    @post_h.rate rating.to_i, current_user
    # Update rating status
    score_good = @post_h.score_good
    score_bad = @post_h.score_bad
    
    if score_good > score_bad
      status = "Good"
    elsif score_good == score_bad
      status = "Require Rating"
    else
      status = "Bad"
    end
    
    @post_h.rating_status = status
    
    @post_h.save
    #support for rate like/dislike cmts
    @str_class = "PostHousing"
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
    @posts = PostHousing.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  # GET /post_housings/1
  # GET /post_housings/1.xml
  def show
    @post_housing = PostHousing.find(params[:id])
    @post = @post_housing.post
    @housing_category_id = params[:housing_category_id]
    update_view_count(@post)
    posts_as = PostHousing.with_school(@school).with_category(@housing_category_id)
    as_next = posts_as.nexts(@post_housing.id).last
    as_prev = posts_as.previous(@post_housing.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_housing }
    end
  end
  
  # GET /post_housings/new
  # GET /post_housings/new.xml
  def new
    @post_housing = PostHousing.new
    @post = Post.new
    @post_housing.post = @post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_housing }
    end
  end
  
  # GET /post_housings/1/edit
  def edit
    @post_housing = PostHousing.find(params[:id])
    @post = @post_housing.post
    @tag_list = @post_housing.tags_from(@post.school).join(", ")
  end
  
  # POST /post_housings
  # POST /post_housings.xml
  def create
    params[:post_housing][:housing_category_ids] = params[:housing_category]
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_housing = PostHousing.new(params[:post_housing])
    if @school.nil?
			flash[:error] = "Please select school."
		  render :action => "new"
		else
		  if simple_captcha_valid?    
		    @post.save
		    sc = School.find(@school)
		    sc.tag(@post_housing, :with => @tag_list, :on => :tags)
		    @post_housing.post = @post
		    if @post_housing.save
		      flash[:notice] = "Your post was successfully created."
		      post_wall(@post_housing)
		      redirect_to post_housing_url(@post_housing)
		    else
		      flash[:error] = "Failed to create a new post."
		      render :action => "new"
		    end
		  else
		    flash[:warning] = "Captcha does not match."
		    render :action => "new"
		  end
		end
  end
  
  # PUT /post_housings/1
  # PUT /post_housings/1.xml
  def update
    params[:post_housing][:housing_category_ids] = params[:housing_category]
    params[:post_housing][:housing_category_ids] ||= []
    @post_housing = PostHousing.find(params[:id])
    @post = @post_housing.post
    if (@post_housing.update_attributes(params[:post_housing]) && @post_housing.post.update_attributes(params[:post]))
      sc = School.find(@post.school.id)
      sc.tag(@post_housing, :with => params[:tag], :on => :tags)
      redirect_to post_housing_url(@post_housing)
    end
  end
  
  # DELETE /post_housings/1
  # DELETE /post_housings/1.xml
  def destroy
    @post_housing = PostHousing.find(params[:id])
    @post_housing.post.favorites.destroy_all
    del_post_wall(@post_housing)
    @post_housing.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_housing_path
    @class_name = "PostHousing"
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
    post_housing = PostHousing.find(params[:id])
    post = post_housing.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user))) || current_user.has_role?(:admin)
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
  
end

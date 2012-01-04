# -*- coding: utf-8 -*-
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostPartiesController < ApplicationController 
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :tag, :prefer, :show_rsvp]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag, :prefer, :add_party, :my_party_list, :show_rsvp]
  #before_filter :login_required, :except => [:index, :show, :search, :tag, :prefer, :show_rsvp]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :new, :edit, :search, :tag]
  cache_sweeper :post_sweeper, :only => [:create, :update, :detroy]
  
  # GET /post_parties
  # GET /post_parties.xml
  
  def index
    @rating_status = params[:rating_status]
    @rating_status ||= ""
    @post_results = Rails.cache.fetch("index_#{@class_name}_status#{@rating_status}_#{@school}") do
      PostParty.paginated_post_conditions_with_option(params, @school, @rating_status)
    end
    @posts = @post_results.paginate({:page => params[:page], :per_page => 10})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    @post_p = @post.post_party
    @post_p.rate rating.to_i, current_user
    # Update rating status
    score_good = @post_p.score_good
    score_ok = @post_p.score_ok
    score_bad = @post_p.score_bad
    
    if score_good == score_ok && score_ok == score_bad
      status = "Require Rating"
    else
      sort_rating_status = {"Good" => score_good, "It's Ok" => score_ok, "Bad" => score_bad}
      arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
      status = arr_rating_status.last.first
    end
    
    @post_p.rating_status = status
    
    @post_p.save

    #support for rate like/dislike cmt
    @str_class = "PostParty"

    # Objects cache
    class_name = @post_p.class.name
    school_id = @post.school_id
    Delayed::Job.enqueue(CacheRattingJob.new(@post_p.id, class_name, nil, status, params))
    Delayed::Job.enqueue(CacheRattingJob.new(@post_p.id, class_name, school_id, status, params))

  end
  
  def require_rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    @post_p = @post.post_party
    if !PostParty.find_rated_by(current_user).include?(@post_p)
      @post_p.rate rating.to_i, current_user
      # Update rating status
      score_good = @post_p.score_good
      score_ok = @post_p.score_ok
      score_bad = @post_p.score_bad
      
      if score_good == score_ok && score_ok == score_bad
        status = "Require Rating"
      else
        sort_rating_status = {"Good" => score_good, "It's Ok" => score_ok, "Bad" => score_bad}
        arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
        status = arr_rating_status.last.first
      end
      
      @post_p.rating_status = status
      
      @post_p.save
      # Objects cache
      class_name = @post_p.class.name
      school_id = @post.school_id
      Delayed::Job.enqueue(CacheRattingJob.new(@post_p.id, class_name, nil, status, params))
      Delayed::Job.enqueue(CacheRattingJob.new(@post_p.id, class_name, school_id, status, params))
    end
    render :layout => false
  end
  
  def tag
    @tag_name = params[:tag_name]
    @posts = PostParty.paginated_post_conditions_with_tag(params, @school, @tag_name)
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
  
  # GET /post_parties/1
  # GET /post_parties/1.xml
  def show
    @post_party = PostParty.find(params[:id])
    @post = @post_party.post
    @rating_status = @post_party.rating_status
    update_view_count(@post)
    if @rating_status
      posts_as = PostParty.with_school(@school).with_status(@rating_status)
    else
      posts_as = PostParty.with_school(@school)
    end
    as_next = posts_as.nexts(@post_party.id).last
    as_prev = posts_as.previous(@post_party.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_party }
    end
  end
  
  def add_party
    post_party_id = params[:post_party_id]
    post = Post.find(post_party_id)
    party_list = PartysList.find_or_create_by_user_id_and_post_party_id(current_user.id, post.post_party.id)
    party_lists = current_user.partys_lists
    @text = "<span class='btmPartyList'>"
    @text << "<a title='My party list' class='thickbox' href='/post_parties/my_party_list?height=400&amp;width=470' class = 'thickbox' title = 'My party list'><span>My party list</span></a>"
    @text << "</span>"
  end
  
  def my_party_list
    @partys_lists = current_user.partys_lists.order("created_at DESC")
    render :layout => false
  end
  
  def delete_party_list
    party_list = PartysList.find(params[:id])
    current_user.partys_lists.delete(party_list) if party_list
    render :text => "Success."
  end
  
  def show_rsvp
    @post = Post.find(params[:post_id])
    render :layout => false
  end
  
  def sendmail
    @post = Post.find(params[:post_id])
    QaSendMail.send_rsvp(current_user,params,@post).deliver
    @receiver = @post.user.name
    render :layout => false
  end
  
  def create_rsvp
    post = Post.find(params[:post_id])
    post_party_rsvp = PostPartyRsvp.new
    post_party_rsvp.where = params[:where]
    post_party_rsvp.when = params[:when]
    post_party_rsvp.first_name = params[:first_name]
    post_party_rsvp.last_name = params[:last_name]
    post_party_rsvp.email = params[:email]
    post_party_rsvp.tel = params[:tel]
    post_party_rsvp.message = params[:message]
    post_party_rsvp.save
    post.post_party.post_party_rsvps << post_party_rsvp
    render :text => "Success"
  end
  
  # GET /post_parties/new
  # GET /post_parties/new.xml
  def new
    @post_party = PostParty.new
    @post = Post.new
    @post_party.post = @post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_party }
    end
  end
  
  # GET /post_parties/1/edit
  def edit
    @post_party = PostParty.find(params[:id])
    @post = @post_party.post
    @tag_list = @post_party.tags_from(@post.school).join(", ")
  end
  
  # POST /post_parties
  # POST /post_parties.xml
  def create
    params[:post_party][:party_type_ids] = params[:party_type]
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_party = PostParty.new(params[:post_party])
    @post_party.start_time = DateTime.strptime(params[:start_time], "%m/%d/%Y %I:%M %p") if params[:start_time] != ""
    @post_party.end_time = DateTime.strptime(params[:end_time], "%m/%d/%Y %I:%M %p") if params[:end_time] != ""
    
    if simple_captcha_valid?  
      @post.save    
      sc = School.find(@school)
      sc.tag(@post_party, :with => @tag_list, :on => :tags)
      @post_party.post = @post
      if @post_party.save
        flash[:notice] = "Your post was successfully created."
        post_wall(@post_party)
        redirect_to post_party_url(@post_party)
      else
        flash[:error] = "Failed to create a new post."
        render :action => "new"
      end
    else
      flash[:warning] = "Captcha does not match."
      render :action => "new"
    end
  end
  
  # PUT /post_parties/1
  # PUT /post_parties/1.xml
  def update
    params[:post_party][:party_type_ids] = params[:party_type]
    params[:post_party][:party_type_ids] ||= []
    @post_party = PostParty.find(params[:id])
    @post = @post_party.post
    
    if (@post_party.update_attributes(params[:post_party]) && @post_party.post.update_attributes(params[:post]))
      @post_party.start_time = DateTime.strptime(params[:start_time], "%m/%d/%Y %I:%M %p") if params[:start_time] != ""
      @post_party.end_time = DateTime.strptime(params[:end_time], "%m/%d/%Y %I:%M %p") if params[:end_time] != ""
      sc = School.find(@post.school.id)
      sc.tag(@post_party, :with => params[:tag], :on => :tags)
      redirect_to post_party_url(@post_party)
    end
  end
  
  # DELETE /post_parties/1
  # DELETE /post_parties/1.xml
  def destroy
    @post_party = PostParty.find(params[:id])
    @post_party.post.favorites.destroy_all
    del_post_wall(@post_party)
    @post_party.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  def prefer
    render :layout => false
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_party_path
    @class_name = "PostParty"
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
    post_party = PostParty.find(params[:id])
    post = post_party.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user))) || current_user.has_role?(:admin)
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
  
end

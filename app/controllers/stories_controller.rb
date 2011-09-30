# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class StoriesController < ApplicationController
  include ApplicationHelper
  layout 'student_lounge'
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :require_current_user, :only => [:edit, :update, :destroy, :delete_comment]
  # GET /stories
  # GET /stories.xml
  def index
    arr_user_id = []
    current_user.user_friends.collect {|f| arr_user_id << f.id if check_private_permission(f, "my_stories")}
    cond = Caboose::EZ::Condition.new :stories do
      user_id === arr_user_id
      state == "share"
    end
    @my_stories = current_user.stories.find(:all, :conditions => "state = 'share'", :order => "created_at DESC").paginate :page => params[:page], :per_page => 5
    @friend_stories = Story.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 5
  end
  
  def friend_s
    arr_user_id = []
    
    if current_user.user_friends
      current_user.user_friends.each do |friend|
        arr_user_id << friend.id if check_private_permission(friend, "my_stories")
      end
    end
    
    @search_name = ""
    
    if params[:search]
      @search_name = params[:search][:name]
    end
    
    content_search = @search_name
    
    cond = Caboose::EZ::Condition.new :stories do
      user_id === arr_user_id
      state == "share"
      if content_search != ""
        any do
          title =~ "%#{content_search}%"
          content =~ "%#{content_search}%"
        end
      end
    end
    
    @stories = Story.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 5
    
    render :layout => false
  end
  
  def my_s
    @search_name = ""
    if params[:search]
      @search_name = params[:search][:name]
    end
    
    content_search = @search_name
    id = current_user.id
    cond = Caboose::EZ::Condition.new :stories do
      user_id == id
      state == "share"
      if content_search != ""
        any do
          title =~ "%#{content_search}%"
          content =~ "%#{content_search}%"
        end
      end
    end
    
    @stories = Story.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 5
    
    render :layout => false
  end
  
  def draft
    @stories = current_user.stories.find(:all, :conditions => "state = 'draft'", :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
  end
  
  def my_draft
    @search_name = ""
    if params[:search]
      @search_name = params[:search][:name]
    end
    
    content_search = @search_name
    id = current_user.id
    cond = Caboose::EZ::Condition.new :stories do
      user_id == id
      state == "draft"
      if content_search != ""
        any do
          title =~ "%#{content_search}%"
          content =~ "%#{content_search}%"
        end
      end
    end
    
    @stories = Story.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    
    render :layout => false
  end
  
  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find(params[:id])
    @user = @story.user
    if check_private_permission(@user, "my_stories")
      update_view_count(@story)
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @story }
      end
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  # GET /stories/new
  # GET /stories/new.xml
  def new
    @story = Story.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
    end
  end
  
  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
  end
  
  # story /stories
  # story /stories.xml
  def create
    state = params[:state]
    @story = Story.new(params[:story])
    @story.user = current_user
    content = Hpricot(params[:story][:content])
    content.search("img").each {|e| e.attributes['src'] = "/gadgets_proxy/link?url=#{e.attributes['src']}" if e.attributes['src'].index('http') == 0}
    content.search("a").each {|e| e.attributes['href'] = "/gadgets_proxy/link?url=#{e.attributes['href']}" if e.attributes['href'].index('http') == 0}
    @story.content = content.to_html
    respond_to do |format|
      if @story.save
        @story.state = state
        @story.save
        flash[:notice] = 'Story was successfully created.'
        if state == "share"
          post_wall(@story) if check_private_permission("my_stories")
          path = user_stories_path(current_user)
        else
          path = draft_user_stories_path(current_user)
        end
        format.html { redirect_to(path) }
        format.xml  { render :xml => @story, :status => :created, :location => @story }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /stories/1
  # PUT /stories/1.xml
  def update
    state = params[:state]
    @story = Story.find(params[:id])
    @story.state = state
    respond_to do |format|
      if @story.update_attributes(params[:story])
        content = Hpricot(params[:story][:content])
        content.search("img").each {|e| e.attributes['src'] = "/gadgets_proxy/link?url=#{e.attributes['src']}" if e.attributes['src'].index('http') == 0}
    content.search("a").each {|e| e.attributes['href'] = "/gadgets_proxy/link?url=#{e.attributes['href']}" if e.attributes['href'].index('http') == 0}
        @story.content = content.to_html
        @story.save
        flash[:notice] = 'Story was successfully updated.'
        format.html { redirect_to(user_stories_path(current_user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @story = Story.find(params[:id])
    @story.favorites.destroy_all
    del_post_wall(@story)
    @story.destroy
    
    respond_to do |format|
      format.html { redirect_to(stories_url) }
      format.xml  { head :ok }
    end
  end
  
  def create_comment
    story_id = params[:story_id]
    comment = params[:comment]
    if comment
      obj_comment = Comment.new()
      obj_comment.comment = comment
      obj_comment.user = current_user
      story = Story.find(story_id)
      story.comments << obj_comment
      redirect_to story
    end
  end
  
  def delete_comment
    story_id = params[:story_id]
    comment_id = params[:comment_id]
    if comment_id && story_id
      story = current_user.stories.find_by_id(story_id)
      story.comments.find_by_id(comment_id).destroy
      redirect_to story
    end
  end
  
  def delete_all
    list_ids = params[:list_ids]
    list_ids = list_ids.slice(0..list_ids.length - 2)
    ids = list_ids.split(", ")
    stories = current_user.stories.find(:all, :conditions => ["id IN(#{ids.join(", ")})"])
    if stories.size > 0
      stories.each do |abl|
        del_post_wall(abl)
        abl.destroy
      end
    end
    redirect_to(user_stories_url(current_user))
  end
  
  protected
  
  def require_current_user
    @user ||= Story.find(params[:story_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class StoriesController < ApplicationController
  layout 'student_lounge'
  
  include Viewable
  
  before_filter :login_required
  before_filter :require_current_user, :only => [:edit, :update, :destroy, :delete_comment]
  # GET /stories
  # GET /stories.xml
  def index
    arr_user_id = []
    current_user.user_friends.collect {|f| arr_user_id << f.id}
    cond = Caboose::EZ::Condition.new :stories do
      user_id === arr_user_id
    end
    @my_stories = current_user.stories.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    @friend_stories = Story.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
  end

  def my_s
    arr_user_id = []
    arr_user_id << current_user.id
    if current_user.user_friends
      current_user.user_friends.each do |friend|
        arr_user_id << friend.id
      end
    end

    @search_name = ""

    if params[:search]
      @search_name = params[:search][:name]
    end

    content_search = @search_name

    cond = Caboose::EZ::Condition.new :stories do
      user_id === arr_user_id
      if content_search != ""
        content =~ "%#{content_search}%"
      end
    end

    @stories = Story.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    
    render :layout => false
  end

  def friend_s
    render :layout => false
  end

  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find(params[:id])
    update_view_count(@story)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @story }
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
    @story = Story.new(params[:story])
    @story.user = current_user

    respond_to do |format|
      if @story.save
        flash[:notice] = 'Story was successfully created.'
        format.html { redirect_to(stories_url) }
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
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        flash[:notice] = 'Story was successfully updated.'
        format.html { redirect_to(@story) }
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
  
  protected

  def require_current_user
    @user ||= Story.find(params[:story_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

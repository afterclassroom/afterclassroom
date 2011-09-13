# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PhotosController < ApplicationController
  include ApplicationHelper
  layout "student_lounge"
  
  session :cookie_only => false, :only => :upload
  skip_before_filter :verify_authenticity_token, :only => :upload
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy]
  
  # GET /photos
  # GET /photos.xml
  def index
    @friend_photos = []
    arr_user_id = []
    @photo_albums = current_user.photo_albums
    current_user.user_friends.collect {|f| arr_user_id << f.id if check_private_permission(f, "my_photos")}
    if arr_user_id.size > 0
      cond = Caboose::EZ::Condition.new :photo_albums do
        user_id === arr_user_id
      end
      @friend_photos = PhotoAlbum.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    end
    @my_photos = current_user.photo_albums.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
  end
  
  def friend_p
    arr_user_id = []
    
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
    
    cond = Caboose::EZ::Condition.new :photo_albums do
      user_id === arr_user_id
      if content_search != ""
        any do
          name =~ "%#{content_search}%"
        end
      end
    end
    
    @photo_albums = PhotoAlbum.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    
    render :layout => false
  end
  
  def my_p
    @search_name = ""
    
    if params[:search]
      @search_name = params[:search][:name]
    end
    
    content_search = @search_name
    id = current_user.id
    cond = Caboose::EZ::Condition.new :photo_albums do
      if content_search != ""
        any do
          name =~ "%#{content_search}%"
        end
      end
      user_id == id
    end
    
    @photo_albums = PhotoAlbum.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    
    render :layout => false
  end
  
  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])
    @photo_album = @photo.photo_album
    @user = @photo.user
    
    #display user for partial on_this_photo
    list_friends = current_user.user_friends
    tagged_ids = TagInfo.find(:all, :conditions => ["tagable_id=? and tagable_type=? and verify=?",params[:id],"Photo",true])
    usr_ids = tagged_ids.map(&:tagable_user)
    @tag_usr = list_friends.select { |c| usr_ids.include?(c.id) }
    
    #find all the user need to be verified
    id_for_verify = TagInfo.find(:all, :conditions => ["tagable_id=? and tagable_type=? and verify=?",params[:id],"Photo",false])
    usr_ids_for_verify = id_for_verify.map(&:tagable_user)
    @usrs_for_verify = list_friends.select { |c| usr_ids_for_verify.include?(c.id) }
    
    if check_private_permission(@user, "my_photos")
      as_next = @photo_album.photos.nexts(@photo.id).last
      as_prev = @photo_album.photos.previous(@photo.id).first
      @next = as_next if as_next
      @prev = as_prev if as_prev 
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @photo }
      end
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  # GET /photos/new
  # GET /photos/new.xml
  def new
    @photo_albums = current_user.photo_albums
    photo_album_id = params[:photo_album_id]
    
    @photo = Photo.new
    @photo.photo_album_id = photo_album_id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end
  
  # GET /photos/1/edit
  def edit
    @photo_albums = current_user.photo_albums
    @photo = Photo.find(params[:id])
    @tag_list = @photo.tag_list.join(", ")
    render :layout => false
  end
  
  # POST /photos
  # POST /photos.xml
  def create
    begin
      @photo = Photo.new(params[:photo])
      @photo.user = current_user
      @photo.tag_list = params[:tag_list]
      respond_to do |format|
        if @photo.save
          flash[:notice] = 'Photo was successfully created.'
          post_wall(@photo) if check_private_permission(current_user, "my_photos")
          format.html { redirect_to user_photo_path(current_user, @photo) }
          format.xml  { render :xml => @photo, :status => :created, :location => @photo }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
        end
      end
    rescue
      flash[:error] = 'Error.'
      render :action => "new"
    end
  end
  
  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])
    
    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        @photo.tag_list = params[:tag_list]
        @photo.save
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to(user_photo_album_url(current_user, @photo.photo_album)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.favorites.destroy_all
    del_post_wall(@photo)
    @photo.destroy
    
    render :nothing => true
  end
  
  def upload
    @photo = Photo.new(params[:photo])
    @photo.user = current_user
    if @photo.save
      render :json => { :id => @photo.id, :pic_path => @photo.photo_attach.url.to_s , :name => @photo.photo_attach.instance.attributes["photo_attach_file_name"] }, :content_type => 'text/html'
    else
      render :json => { :result => 'error'}, :content_type => 'text/html'
    end
  end
  
  def create_form
  end
  
  def create_album
    @photo_album = PhotoAlbum.new(params[:photo_album])
    @photo_album.user = current_user
    @photo_album.save
    post_wall(@photo_album) if check_private_permission(current_user, "my_photos")
    render :layout => false
  end
  
  def show_album
    photo_album_id = params[:photo_album_id]
    @photo_album = PhotoAlbum.find(photo_album_id)
    update_view_count(@photo_album)
    @user = @photo_album.user
    if check_private_permission(@user, "my_photos")
      @another_photo_albums = @photo_album.another_photo_albums
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @photo_album }
      end
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def phototag
    taginfo = TagInfo.find(:all,:conditions => ["tagable_id =? and tagable_type = ? and verify=?", params[:photo_id], "Photo", true])
    @testinfo = nil
        
    taginfo_id = taginfo.map(&:id)
    @res = TagPhoto.find(:all, :conditions => ["tag_info_id in (?)", taginfo_id])
    
    deletable = false
    current_photo = Photo.find(params[:photo_id])
    if (current_user == current_photo.user)
      deletable = true
    end
    
    arr1 = []
    @res.each do |tagphoto|
      tag_info = tagphoto.tag_info
      usr = User.find(tag_info.tagable_user)
      objx={
        :id=>usr.id,  
        :text=>usr.name,
        :left=> tagphoto.left,
        :top=>tagphoto.top,
        :width=>tagphoto.width,
        :height=>tagphoto.height,
        :url=> user_url(usr),
        :isDeleteEnable=> deletable
      }
      arr1 << objx
    end

    @str = {
      :Image => [
        {
          :id=> params[:photo_id],
          :Tags=> arr1
        }
      ],
      :options=>{
        :literals=> {
          :removeTag=> "Remove tag"
        },
        :tag=>{
          :flashAfterCreation=> true
        }
      }
    }        
    
    respond_to do |format|
      format.js { render :json => @str}
    end
  end
  
  def deletetag
    usrs = []
    usrs << params["tag-id"]
    params[:tag_checkbox] = usrs
    
    TagInfo.refuse_photo(params[:tag_checkbox],params[:photo_id])
    
    obj = {
      :result => true,
      :message => "ooops"}
    respond_to do |format|
      format.js { render :json => obj}
    end
  end
  
  def addtag
    photo = Photo.find(params[:photo_id])
    
    taginfo = TagInfo.new()
    taginfo.tag_creator_id = current_user.id
    taginfo.tagable_id = params[:photo_id]
    taginfo.tagable_user = params[:name_id]
    taginfo.tagable_type = "Photo"
    taginfo.verify = false
    if current_user == photo.user
      taginfo.verify = true
    end
    taginfo.save
    
    tagphoto = TagPhoto.new()
    tagphoto.tag_info = taginfo
    tagphoto.left=params[:left]
    tagphoto.top=params[:top]
    tagphoto.width=params[:width]
    tagphoto.height=params[:height]
    tagphoto.save
    
    usr = User.find(params[:name_id])
    
    arr = {
      "result"=>true,
      "tag"=> {
        "id"=> usr.id,
        "text"=> usr.name,
        "left"=> params[:left],
        "top"=> params[:top],
        "width"=> params[:width],
        "height"=> params[:height],
        "url"=> user_url(usr),
        "isDeleteEnable"=> true
      }
    }    
    
    respond_to do |format|
      format.js { render :json => arr.to_json()}
    end
  end
  
  def usrdata
    arr = []
    
    list_friends = current_user.user_friends
    friends = []
    list_friends.select {|usr| friends << usr if usr.name.downcase.start_with? params[:term].to_s.downcase }
    
    tagged_friends = TagInfo.find(:all, :conditions => ["tagable_id=? and tagable_type=?",params[:photo_id],"Photo"])
    tagged_user_ids = tagged_friends.map(&:tagable_user) #array user_id of has been tagged so that should not display to user to see
    filtered_friends = friends.select { |c| !tagged_user_ids.include?(c.id) }
    
    filtered_friends.each do |usr|
      obj = { 
        :id=> usr.id, 
        :label => usr.name, 
        :value=> usr.name 
      }
      arr << obj
    end
    
    respond_to do |format|
      format.js { render :json => arr.to_json()}
    end
  end
  
  def tag_decision
    photo = Photo.find(params[:photo_id])
    if params[:decision_id] == "ACCEPT"
      TagInfo.verify_photo(params[:checkbox],params[:photo_id])
    else
      TagInfo.refuse_photo(params[:checkbox],params[:photo_id])
    end
    
    redirect_to :controller=>'photos', :action => 'show', :id => params[:photo_id]
  end
  
  def remove_tagged
    TagInfo.refuse_photo(params[:tag_checkbox],params[:photo_id])
    
    redirect_to :controller=>'photos', :action => 'show', :id => params[:photo_id]
  end
  
  protected
  
  def require_current_user
    @user ||= Photo.find(params[:photo_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

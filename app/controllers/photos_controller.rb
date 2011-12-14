# -*- coding: utf-8 -*-
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
    current_user.user_friends.collect {|f| arr_user_id << f.id if check_private_permission(current_user, f, "my_photos")}
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
    @tag_usr = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:id],"Photo",true ] )
    
    #find all the user need to be verified
    #id_for_verify = TagInfo.find(:all, :conditions => ["tagable_id=? and tagable_type=? and verify=?",params[:id],"Photo",false])
    #usr_ids_for_verify = id_for_verify.map(&:tagable_user)
    #@usrs_for_verify = list_friends.select { |c| usr_ids_for_verify.include?(c.id) }
    @usrs_for_verify = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:id],"Photo",false ] )
    
    if check_private_permission(current_user, @user, "my_photos") or check_view_permission(current_user, @photo)
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
          post_wall(@photo)
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
      render :json => { :id => @photo.id, :pic_path => @photo.photo_attach.url.to_s , :name => @photo.photo_attach.instance.attributes["photo_attach_file_name"], :pic_url => user_photo_url(current_user, @photo) }, :content_type => 'text/html'
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
    post_wall(@photo_album)
    render :layout => false
  end
  
  def show_album
    photo_album_id = params[:photo_album_id]
    @photo_album = PhotoAlbum.find(photo_album_id)
    update_view_count(@photo_album)
    @user = @photo_album.user
    if check_private_permission(current_user, @user, "my_photos") or check_view_permission(current_user, @photo_album)
      @another_photo_albums = @photo_album.another_photo_albums
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @photo_album }
      end
    else
      redirect_to warning_user_path(@user)
    end
  end

	def show_album_with_list
    photo_album_id = params[:photo_album_id]
    @photo_album = PhotoAlbum.find(photo_album_id)
    update_view_count(@photo_album)
    @user = @photo_album.user
    if check_private_permission(current_user, @user, "my_photos") or check_view_permission(current_user, @photo_album)
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
      #allow tagCreator able to delete tag that he created
      if tagphoto.tag_info.tag_creator_id == current_user.id        
        deletable = true
      end

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

    #BEGIN: display tags has not VERIFIED by owner, but current_user is the tag_creator
    taginfo_pending = TagInfo.find(:all,:conditions => ["tagable_id =? and tagable_type = ? and verify=? and tag_creator_id=?", params[:photo_id], "Photo", false, current_user.id])

    taginfo_pending_id = taginfo_pending.map(&:id)
    @res_pending = TagPhoto.find(:all, :conditions => ["tag_info_id in (?)", taginfo_pending_id])
    @res_pending.each do |tagphoto|
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
        :isDeleteEnable=> true
      }
      arr1 << objx
    end
    #END: display tags has not VERIFIED by owner, but current_user is the tag_creator


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
    u = User.find(params["tag-id"])
    photo = Photo.find(params[:photo_id])
    QaSendMail.tag_photo_removed(u,photo,current_user).deliver
    
    obj = {
      :result => true,
      :message => "ooops"}
    respond_to do |format|
      format.js { render :json => obj}
    end
  end
  
  def addtag
    photo = Photo.find(params[:photo_id])
    usr = User.find(params[:name_id])
    
    taginfo = TagInfo.new()
    taginfo.tag_creator_id = current_user.id
    taginfo.tagable_id = params[:photo_id]
    taginfo.tagable_user = params[:name_id]
    taginfo.tagable_type = "Photo"
    
    taginfo.verify = false
    if current_user == photo.user
      taginfo.verify = true
      if photo.user != usr
        #This is the case 5, please refer to below comment
        TagPhotoMail.inform_user_been_tagged_by_author(photo, usr).deliver
      end
    else
      pr = photo.user.private_settings.where(:type_setting => "tag_photo").first
      if (pr != nil)
        if (TAGS_SETTING[pr.share_to][0] != "Verify")#which mean NO VERIFY
          taginfo.verify = true
        end
      else#user has not setting this, considered NO VERIFY BY DEFAULT
        taginfo.verify = true
      end
    end

    deletable = false
    if (current_user == photo.user)
      deletable = true
    end    
    
    if taginfo.save
      
      tagphoto = TagPhoto.new()
      tagphoto.tag_info = taginfo
      tagphoto.left=params[:left]
      tagphoto.top=params[:top]
      tagphoto.width=params[:width]
      tagphoto.height=params[:height]
    
      if tagphoto.save
        if taginfo.verify == false #author enable verify of tag
          #CASE 1: if tag_creator tag him self, send mail to him self, inform him 
          #to wait for authorization, send another mail to author to inform him 
          #to authorize for tag-creator
          #CASE 2: if tag_creator tag author, send mail to him self, inform 
          #him to wait for authorization, send another mail to author to 
          #inform him to authorize for tag-creator
          #CASE 3: if tag_creator tag another user, send 1 mail to tag-creator 
          #to inform him to wait for authorization, DO NOT INFORM USER2 , 
          #inform author to authorize for tag-creator
          #CASE 4: if author tag him self : no verify, no send mail, 
          #update taginfor.verify = true and save
          #CASE 5: if author tag another user : no verify, no send mail to 
          #author, send mail to other user about has been tagged
          puts "currentusre = #{current_user.name}"
          puts "usr = #{usr.name}"
          puts "photo user = #{photo.user.name}"
          case current_user
          when photo.user #tag creator is the author
            case usr
            when photo.user #case 4:: has been implemented above; at the same place with case 5
            else #case 5, author tag another user:: has been implemented above
            end
          else #tag creator is not video author
            case usr
            when current_user #case 1
              TagPhotoMail.inform_creator_to_wait_case1(photo, current_user).deliver
              TagPhotoMail.inform_author_to_authorize_case1(photo, current_user).deliver
            when photo.user #case 2
              TagPhotoMail.inform_creator_to_wait_case2(photo, current_user).deliver
              TagPhotoMail.inform_author_to_authorize_case2(photo, current_user).deliver
            else #another user #case 3
              TagPhotoMail.inform_creator_to_wait_case3(photo, usr,current_user).deliver
              TagPhotoMail.inform_author_to_authorize_case3(photo, usr,current_user).deliver
            end
          end              
        else#taginfo.verify == true ::author disable verify of tag
          #CASE 1: if tag_creator tag him self, send mail to him self, inform him 
          #the tag added successful, send mail to author about new tag created.
          #CASE 2: if tag_creator tag author, send mail to him self, inform 
          #the tag created success, send another mail to author to inform he has been tagged
          #CASE 3: if tag_creator tag another user, send 1 mail to tag-creator 
          #to inform him tag created success, send mail to user 2 that he has been tagged
          #CASE 4: if author tag him self : no send mail
          #CASE 5: if author tag another user : no send mail to 
          #author, send mail to other user about has been tagged
          case current_user
          when photo.user #tag creator is the author
            case usr
            when photo.user #case 4:: has been implemented above; at the same place with case 5
            else #case 5, author tag another user:: has been implemented above
            end
          else #tag creator is not video author
            case usr
            when current_user #case 1
              TagPhotoMail.inform_creator_self_tag_success(photo,current_user).deliver
              TagPhotoMail.inform_author_creator_self_tag_success(photo,current_user).deliver
            when photo.user #case 2
              TagPhotoMail.inform_creator_tag_of_author_success(photo,current_user).deliver
              TagPhotoMail.inform_author_tag_of_author_success(photo,current_user).deliver
            else #another user #case 3
              TagPhotoMail.inform_creator_tag_of_user_success(photo,current_user,usr).deliver
              TagPhotoMail.inform_author_tag_of_user_success(photo,current_user,usr).deliver
              TagPhotoMail.inform_user_been_tagged(photo,current_user,usr).deliver
            end
          end 
        end
      end
    end
    
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
        "isDeleteEnable"=> true#deletable
      }
    }    
    
    respond_to do |format|
      format.js { render :json => arr.to_json()}
    end
  end #end action add tag
  
  def usrdata
    list_friends = []
    
    
    current_user.user_friends.each do |usr|
      list_friends << usr
    end
    
    list_friends << current_user
    puts "after == #{list_friends.size}"

    #friends = list_friends.select { |usr| usr.name.downcase.start_with? params[:term].to_s.downcase }
    friends = list_friends.select { |usr| usr.name.downcase.include?(params[:term].to_s.downcase)  }
    #if @var.include?("string")
    
    tagged_friends = TagInfo.find(:all, :conditions => ["tagable_id=? and tagable_type=?",params[:photo_id],"Photo"])
    tagged_user_ids = tagged_friends.map(&:tagable_user) #array user_id of has been tagged so that should not display to user to see
    filtered_friends = friends.select { |c| !tagged_user_ids.include?(c.id) }
    
    arr = []
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
      share_to = params[:checkbox]
      share_to.each do |i|
        u = User.find(i)
        if u
          tag_creator = User.find(:first, :joins => "INNER JOIN tag_infos ON tag_infos.tag_creator_id = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=? and tag_infos.tagable_user=?",params[:photo_id],"Photo",true, u.id ] )
          #case 1: tag-creator make own tag, send 1 mail to tag creator
          #case 2: tag-creator tag author, send 1 mail to tag creator
          #case 3: tag-creator tag user, send 1 mail to tag creator, 1 mail to user
          case u
          when tag_creator #case 1
            TagPhotoMail.inform_creator_own_tag_accepted(photo,tag_creator).deliver
          when photo.user #case 2
            TagPhotoMail.inform_creator_author_tag_accepted(photo,tag_creator).deliver
          else #case 3
          end
          
#          QaSendMail.tag_photo_approved(u,photo,current_user).deliver
          

          #if tag_creator != u #do not send second mail when tag_creator tag him/her-self
#            QaSendMail.tag_photo_approved_to_creator(tag_creator,photo,current_user,u).deliver
          #end
        end
      end #end each      
    else
      share_to = params[:checkbox]
      share_to.each do |i|
        u = User.find(i)
        if u
#          QaSendMail.tag_photo_removed(u,photo,current_user).deliver


          tag_creator = User.find(:first, :joins => "INNER JOIN tag_infos ON tag_infos.tag_creator_id = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=? and tag_infos.tagable_user=?",params[:photo_id],"Photo",false, u.id ] )
          if tag_creator != u #do not send second mail when tag_creator tag him/her-self
#            QaSendMail.tag_photo_removed_to_creator(tag_creator,photo,current_user,u).deliver
          end
        end
      end #end each      
      TagInfo.refuse_photo(params[:checkbox],params[:photo_id])

    end
    
    redirect_to :controller=>'photos', :action => 'show', :id => params[:photo_id]
  end #end action tag_decision
  
  def remove_tagged
    photo = Photo.find(params[:photo_id])
    TagInfo.refuse_photo(params[:tag_checkbox],params[:photo_id])
    share_to = params[:tag_checkbox]
    share_to.each do |i|
      u = User.find(i)
      if u
        QaSendMail.tag_photo_removed(u,photo,current_user).deliver
      end
    end #end each
    
    redirect_to :controller=>'photos', :action => 'show', :id => params[:photo_id]
  end

  def self_untag
    user_to_remove = ["#{current_user.id}"]
    TagInfo.refuse_photo(user_to_remove,params[:photo_id])
    @photo = Photo.find(params[:photo_id])
  end
  
  def comment_inform
    @tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:photo_id],"Photo",true ] )
    @photo = Photo.find(params[:photo_id])
    
    #send mail to author
    QaSendMail.photo_cmt_added(@photo.user,@photo,params[:comment_content],current_user).deliver
    
    #and then send mail to tagged user
    if @tagged_users.size > 0
      @tagged_users.each do |user|
        if user != current_user
          QaSendMail.photo_cmt_added(user,@photo,params[:comment_content],current_user).deliver
        end
      end #end each
    end #end if

    
    render :text => "Done"
  end
  
  def rate
    rating = params[:rating]
    @post = Photo.find(params[:post_id])
    @post.rate rating.to_i, current_user
    @post.save
    
    @text = "<div class='qashdU'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@post.total_good}</a></div>"
    @text << "<div class='qashdD'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@post.total_bad}</a></div>"
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

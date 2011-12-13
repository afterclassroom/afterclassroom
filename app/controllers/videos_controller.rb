# -*- coding: utf-8 -*-
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class VideosController < ApplicationController
  layout "student_lounge"
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :require_current_user,
    :only => [:edit, :update]
  # GET /videos
  # GET /videos.xml
  def index
    @friend_videos = []
    arr_user_id = []
    current_user.user_friends.collect {|f| arr_user_id << f.id if check_private_permission(current_user, f, "my_videos")}
    if arr_user_id.size > 0
      cond = Caboose::EZ::Condition.new :videos do
        user_id === arr_user_id
        state == "converted"
      end
      @friend_videos = Video.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    end
    @my_videos = current_user.videos.find(:all, :conditions => ["state = ?", "converted"], :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
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
    
    cond = Caboose::EZ::Condition.new :videos do
      user_id === arr_user_id
      if content_search != ""
        any do
          title =~ "%#{content_search}%"
          description =~ "%#{content_search}%"
        end
      end
			state == "converted"
    end
    
    @videos = Video.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    
    render :layout => false
  end
  
  def my_p
    @search_name = ""
    
    if params[:search]
      @search_name = params[:search][:name]
    end
    
    content_search = @search_name
    id = current_user.id
    cond = Caboose::EZ::Condition.new :videos do
      if content_search != ""
        any do
          title =~ "%#{content_search}%"
          description =~ "%#{content_search}%"
        end
      end
      user_id == id
      state == "converted"
    end
    
    @videos = Video.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    
    render :layout => false
  end
  
  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = Video.find(params[:id])
    @user = @video.user
    
    if check_private_permission(current_user, @user, "my_videos") or check_view_permission(current_user, @video)
      update_view_count(@video)
      as_next = @user.videos.nexts(@video.id).last
      as_prev = @user.videos.previous(@video.id).first
      @next = as_next if as_next
      @prev = as_prev if as_prev
      
      #list of user has been tagged, and been verified
      @tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:id],"Video",true ] )
      @verify_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:id],"Video",false ] )

      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @video }
      end
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  # GET /videos/new
  def new
    @categories ||= Youtube.video_categories
    @video = Video.new()
  end
  
  # GET /videos/1/edit
  def edit
    @categories ||= Youtube.video_categories
    @video = Video.find(params[:id])
    @tag_list = @video.tag_list.join(", ")
    render :layout => false
  end
  
  # POST /videos
  # POST /videos.xml
  def create
    begin
      @video = Video.new(params[:video])
      @video.user = current_user
      @video.tag_list = params[:tag_list]
      if @video.save!
        @video.convert
				if @video.state == "error"
					flash[:error] = 'Convert video error.'
					@video.destroy
					render :action => "new"
				else
					post_wall(@video)
        	flash[:notice] = 'Video was successfully created.'
					redirect_to(user_video_url(current_user, @video))
				end
      else
        flash[:error] = 'Error.'
        @categories ||= Youtube.video_categories
        render :action => "new"
      end
    rescue
      flash[:error] = 'Error.'
      @categories ||= Youtube.video_categories
      render :action => "new"
    end
  end
  
  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    @video = Video.find(params[:id])
    
    respond_to do |format|
      if @video.update_attributes(params[:video])
        @video.tag_list = params[:tag_list]
        @video.save
        flash[:notice] = 'Video was successfully updated.'
        format.html { redirect_to(update_video_user_videos_url(@video.user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def create_form
    @categories ||= Youtube.video_categories
    @video = Video.new()
  end
  
  def update_video
    @videos = current_user.videos.find(:all, :order => "created_at DESC")
  end
  
  def delete_videos
    list_ids = params[:list_ids]
    list_ids = list_ids.slice(0..list_ids.length - 2)
    ids = list_ids.split(", ")
    videos = current_user.videos.find(:all, :conditions => ["id IN(#{ids.join(", ")})"])
    if videos.size > 0
      videos.each do |abl|
        tools = Learntool.find(:all, :conditions => ["video_id = ?", abl.id])
        if tools.size > 0
          Learntool.update_all({:video_id => nil}, {:video_id => abl.id})
        end
        
        del_post_wall(abl)
        abl.favorites.destroy_all
        abl.destroy
      end
    end
    redirect_to(update_video_user_videos_url(current_user))
  end
  
  def add_tag
    
    @video = Video.find(params[:video_id])
    
    share_to = params[:share_to]
    user_ids = share_to.split(",")

    str_flash_msg = "Your request has been sent to author. The approval will be sent to your email."

    if user_ids.size > 0 
      user_ids.each do |i|
        u = User.find(i)
        if u
          #adding selected user into TagInfo
          taginfo = TagInfo.find_or_create_by_tagable_id_and_tagable_user_and_tagable_type(params[:video_id], u.id, "Video")
					
          taginfo.tag_creator_id = current_user.id if taginfo.tag_creator_id.nil?
          taginfo.verify = false if taginfo.verify.nil?
          if current_user == @video.user
            taginfo.verify = true
            
            if @video.user != u
              #This is the case 5, please refer to below comment
              TagVidMail.inform_user_been_tagged_by_author(@video, u).deliver
            end
            flash[:notice] = "Your friend(s) has been tagged."
          else
            pr = @video.user.private_settings.where(:type_setting => "tag_video").first
            if (pr != nil)
              if (TAGS_SETTING[pr.share_to][0] != "Verify")#which mean NO VERIFY
                taginfo.verify = true
                str_flash_msg = "Your tag(s) have been created"
              end
            else#user has not setting this, considered NO VERIFY BY DEFAULT
              taginfo.verify = true
            end
            
            flash[:notice] = str_flash_msg
          end
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          if taginfo.save
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++"
            puts "++ abc"
            puts "++ == #{taginfo.verify}"
            if taginfo.verify == false
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
              case current_user
              when @video.user #tag creator is the author
                case u
                when @video.user #case 4
                  taginfo.verify = true
                  taginfo.save
                else #case 5, author tag another user:: has been implemented above
                end
              else #tag creator is not video author
                case u
                when current_user #case 1
                  TagVidMail.inform_creator_to_wait_case1(@video, current_user).deliver
                  TagVidMail.inform_author_to_authorize_case1(@video, current_user).deliver
                when @video.user #case 2
                  TagVidMail.inform_creator_to_wait_case2(@video, current_user).deliver
                  TagVidMail.inform_author_to_authorize_case2(@video, current_user).deliver
                else #another user #case 3
                  TagVidMail.inform_creator_to_wait_case3(@video, u,current_user).deliver
                  TagVidMail.inform_author_to_authorize_case3(@video, u,current_user).deliver
                end
              end
            else
            end
            #taginfo.verify equal to TRUE when no need to pass to verifying process
            #when there is no need to verify, there is no need to wait for authorization
            #stop send mail when tag_creator tag him/her self
            #            if (u != current_user)
            #              QaSendMail.tag_vid_notify(u,@video, current_user,taginfo.verify).deliver
            #            end
            #            if ( (current_user != @video.user) && (@video.user != u) )
            #              #the above condition is "NOT TO SEND mail to video owner"
            #              #if any user tag OWNER to OWNER's video
            #              QaSendMail.inform_vid_owner(u,@video, current_user,taginfo.verify).deliver
            #            end
          end
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          #if save then send mail to each user here, and to video.user
        end
      end #end each
			
    end
		#list of user has been tagged, and been verified
    @tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:video_id],"Video",true ] )
    @verify_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:video_id],"Video",false ] )
  end
  
  def tag_decision
    video = Video.find(params[:video_id])
    if params[:decision_id] == "ACCEPT"
      TagInfo.verify_vid(params[:checkbox],params[:video_id])
      share_to = params[:checkbox]
      share_to.each do |i|
        u = User.find(i)
        if u
          QaSendMail.tag_approved(u,video,current_user).deliver

          tag_creator = User.find(:first, :joins => "INNER JOIN tag_infos ON tag_infos.tag_creator_id = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=? and tag_infos.tagable_user=?",params[:video_id],"Video",true, u.id ] )
          if tag_creator != u #stop send mail when tag_creator add him/her-self
            #            QaSendMail.tag_vid_approved_to_creator(tag_creator,video,current_user,u).deliver
          end
        end
      end #end each
    else
      share_to = params[:checkbox]
      share_to.each do |i|
        u = User.find(i)
        if u
          QaSendMail.tag_removed(u,video,current_user).deliver
          tag_creator = User.find(:first, :joins => "INNER JOIN tag_infos ON tag_infos.tag_creator_id = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=? and tag_infos.tagable_user=?",params[:video_id],"Video",false, u.id ] )
          if tag_creator != u #stop send mail when tag_creator add him/her-self
            #            QaSendMail.tag_vid_removed_to_creator(tag_creator,video,current_user,u).deliver
          end
        end
      end #end each
      TagInfo.refuse_vid(params[:checkbox],params[:video_id])
    end
    redirect_to :controller=>'videos', :action => 'show', :id => params[:video_id]
  end
  
  def remove_tagged
    video = Video.find(params[:video_id])
    TagInfo.refuse_vid(params[:tag_checkbox],params[:video_id])
    share_to = params[:tag_checkbox]
    share_to.each do |i|
      u = User.find(i)
      if u
        #        QaSendMail.tag_removed(u,video,current_user).deliver
      end
    end #end each

    redirect_to :controller=>'videos', :action => 'show', :id => params[:video_id]
  end
  
  def self_untag
    user_to_remove = ["#{current_user.id}"]
    TagInfo.refuse_vid(user_to_remove,params[:video_id])
    @video = Video.find(params[:video_id])
  end
  
  def comment_inform
    @tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:video_id],"Video",true ] )
    @video = Video.find(params[:video_id])
    
    #and then send mail to tagged user
    if @tagged_users.size > 0
      @tagged_users.each do |user|
        if user != @video.user
          #          QaSendMail.vid_cmt_added(user,@video,params[:comment_content],current_user).deliver
        end
      end #end each
    end #end if
    
    render :text => "Done"
  end

  def rate
    rating = params[:rating]
    @post = Video.find(params[:post_id])
    @post.rate rating.to_i, current_user
    @post.save

    #support for rate like/dislike cmt    
    @str_class = "Video"

    @text = "<div class='qashdU'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@post.total_good}</a></div>"
    @text << "<div class='qashdD'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@post.total_bad}</a></div>"
  end

  def get_on_this_video
    video_id = params[:video_id]
    @video = Video.find(video_id)
    #list of user has been tagged, and been verified
    @tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",video_id,"Video",true ] )
    @verify_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",video_id,"Video",false ] )
  end
  
  protected
  
  def require_current_user
    @user ||= Video.find(params[:video_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

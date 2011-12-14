# -*- coding: utf-8 -*-
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class MusicAlbumsController < ApplicationController
  layout "student_lounge"
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :require_current_user,
                :only => [:edit, :show, :update, :destroy]
  # GET /music_albums
  # GET /music_albums.xml
  def index
    @my_music_albums = current_user.music_albums.find(:all, :order => "created_at DESC")
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_music_albums }
    end
  end
  
  # GET /music_albums/1
  # GET /music_albums/1.xml
  def show
    @music_album = MusicAlbum.find(params[:id])
    @musics = @music_album.musics.find(:all, :order => "created_at DESC")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @music_album }
    end
  end

  # GET /music_albums/1/edit
  def edit
    @music_album = MusicAlbum.find(params[:id])
    render :layout => false
  end

  # PUT /music_albums/1
  # PUT /music_albums/1.xml
  def update
    @music_album = MusicAlbum.find(params[:id])

    respond_to do |format|
      if @music_album.update_attributes(params[:music_album])
        flash[:notice] = 'MusicAlbum was successfully updated.'
        format.html { redirect_to(user_music_albums_url(current_user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @music_album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /music_albums/1
  # DELETE /music_albums/1.xml
  def destroy
    @music_album = MusicAlbum.find(params[:id])
    @music_album.favorites.destroy_all
    del_post_wall(@music_album)
    @music_album.destroy

    respond_to do |format|
      format.html { redirect_to(music_albums_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    list_ids = params[:list_ids]
    list_ids = list_ids.slice(0..list_ids.length - 2)
    ids = list_ids.split(", ")
    music_albums = current_user.music_albums.find(:all, :conditions => ["id IN(#{ids.join(", ")})"])
    if music_albums.size > 0
      music_albums.each do |abl|
        abl.favorites.destroy_all
        del_post_wall(abl)
        abl.destroy
      end
    end
    redirect_to(user_music_albums_url(current_user))
  end
  
  def delete_musics
    music_album = MusicAlbum.find(params[:id])
    list_ids = params[:list_ids]
    list_ids = list_ids.slice(0..list_ids.length - 2)
    ids = list_ids.split(", ")
    musics = current_user.musics.find(:all, :conditions => ["id IN(#{ids.join(", ")})"])
    if musics.size > 0
      musics.each do |abl|
        abl.favorites.destroy_all
        del_post_wall(abl)
        abl.destroy
      end
    end
    redirect_to(user_music_album_url(current_user, music_album))
  end

  def rate
    rating = params[:rating]
    @post = MusicAlbum.find(params[:post_id])
    @post.rate rating.to_i, current_user
    @post.save

    #support for rate like/dislike cmt
    @str_class = "MusicAlbum"
    
    @text = "<div class='qashdU'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@post.total_good}</a></div>"
    @text << "<div class='qashdD'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@post.total_bad}</a></div>"
  end




  def add_tag
    @music_album = MusicAlbum.find(params[:music_album_id])
    str_flash_msg = "Your request has been sent to author. The approval will be sent to your email."
    share_to = params[:share_to]
    user_ids = share_to.split(",")
    if user_ids.size > 0 
      user_ids.each do |i|
        u = User.find(i)
        if u
          #adding selected user into TagInfo
          taginfo = TagInfo.find_or_create_by_tagable_id_and_tagable_user_and_tagable_type(params[:music_album_id], u.id, "MusicAlbum")
          taginfo.tag_creator_id = current_user.id if taginfo.tag_creator_id.nil?
          taginfo.verify = false if taginfo.verify.nil?
          if current_user == @music_album.user
            taginfo.verify = true
            flash[:notice] = "Your friend(s) will listen this album shortly."
          else
            pr = @music_album.user.private_settings.where(:type_setting => "tag_music").first
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
              case current_user
              when @music_album.user #tag creator is the author
                case u
                when @music_album.user #case 4:: has been implemented above; at the same place with case 5
                else #case 5, author tag another user:: has been implemented above
                end
              else #tag creator is not video author
                case u
                when current_user #case 1
                  TagMusicMail.inform_creator_to_wait_case1(@music_album, current_user).deliver
                  TagMusicMail.inform_author_to_authorize_case1(@music_album, current_user).deliver
                when @music_album.user #case 2
                else #another user #case 3
                end
              end
            else #taginfo.verify == true::author disable verify tag
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
              when @music_album.user #tag creator is the author
                case u
                when @music_album.user #case 4:: has been implemented above; at the same place with case 5
                else #case 5, author tag another user:: has been implemented above
                end
              else #tag creator is not video author
                case u
                when current_user #case 1
                when @music_album.user #case 2
                else #another user #case 3
                end
              end              
            end            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
          #   #taginfo.verify equal to TRUE when no need to pass to verifying process
          #   #when there is no need to verify, there is no need to wait for authorization
#            QaSendMail.tag_music_notify(u,@music_album, current_user,taginfo.verify).deliver
#            if ( (current_user != @music_album.user) && (@music_album.user != u) )
#              #the above condition is "NOT TO SEND mail to @music_album owner"
#              #if any user tag OWNER to OWNER's @music_album
#              QaSendMail.inform_music_album_owner(u,@music_album, current_user,taginfo.verify).deliver
#            end
          end
          #if save then send mail to each user here, and to @music_album.user
        end
      end #end each
    end
		#display user that need to verify after add ta
    @usrs_for_verify = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:music_album_id],"MusicAlbum",false ] )
    @tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:music_album_id],"MusicAlbum",true ] )
  end
  
  def tag_decision
    @music_album = MusicAlbum.find(params[:music_album_id])
    if params[:decision_id] == "ACCEPT"
      TagInfo.verify_music(params[:checkbox],params[:music_album_id])
      share_to = params[:checkbox]
      share_to.each do |i|
        u = User.find(i)
        if u
          QaSendMail.tag_music_approved(u,@music_album,current_user).deliver
        end
      end #end each
    else
      TagInfo.refuse_music(params[:checkbox],params[:music_album_id])
      share_to = params[:checkbox]
      share_to.each do |i|
        u = User.find(i)
        if u
          QaSendMail.tag_music_removed(u,@music_album,current_user).deliver
        end
      end #end each
    end
    redirect_to :controller=>'musics', :action => 'play_list', :music_album_id => params[:music_album_id]
  end

  def remove_tagged
    @music_album = MusicAlbum.find(params[:music_album_id])
    TagInfo.refuse_music(params[:tag_checkbox],params[:music_album_id])
    share_to = params[:tag_checkbox]
    share_to.each do |i|
      u = User.find(i)
      if u
        QaSendMail.tag_music_removed(u,@music_album,current_user).deliver
      end
    end #end each

    redirect_to :controller=>'musics', :action => 'play_list', :music_album_id => params[:music_album_id]
  end

  def self_untag
    user_to_remove = ["#{current_user.id}"]
    TagInfo.refuse_music(user_to_remove,params[:music_album_id])
    @music_album = MusicAlbum.find(params[:music_album_id])
  end

  def comment_inform
    @tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:music_album_id],"MusicAlbum",true ] )
    @music_album = MusicAlbum.find(params[:music_album_id])

   
    #and then send mail to tagged user
    if @tagged_users.size > 0
      @tagged_users.each do |user|
        if user != current_user && user != @music_album.user
          QaSendMail.music_cmt_added(user,@music_album,params[:comment_content],current_user).deliver
        end
      end #end each
    end #end if

    
    render :text => "Done"
  end


  protected

  def require_current_user
    @user ||= MusicAlbum.find(params[:music_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end

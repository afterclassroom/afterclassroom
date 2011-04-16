# © Copyright 2009 AfterClassroom.com — All Rights Reserved
include ActionView::Helpers::UrlHelper

class UserWallsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  
  def create_wall
    user_wall_id = params[:user_wall_id]
    your_mind = params[:your_mind]
    @user = User.find(user_wall_id)
    unless @user.nil?
      user_wall = UserWall.new
      user_wall.user_id_post = current_user.id
      user_wall.content = your_mind
      
      if params[:user_wall_photo]
        user_wall_photo = UserWallPhoto.new(params[:user_wall_photo])
        user_wall.user_wall_photo = user_wall_photo
      end
      
      if params[:user_wall_video]
        user_wall_video = UserWallVideo.new(params[:user_wall_video])
        user_wall.user_wall_video = user_wall_video
      end
      
      if params[:user_wall_music]
        user_wall_music = UserWallMusic.new(params[:user_wall_music])
        user_wall.user_wall_music = user_wall_music
      end
      
      if params[:user_wall_link]
        user_wall_link = UserWallLink.new(params[:user_wall_link])
        user_wall.user_wall_link = user_wall_link
      end
      
      user_wall.save
      
      @user.user_walls << user_wall
      @user.save
    end
    @walls = @user.user_walls.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html { redirect_to user_profiles_path(current_user) }
      format.js { 
        render :layout => false
      }
    end
  end
  
  def view_all_comments
    wall_id = params[:wall_id]
    @wall = UserWall.find_by_id(params[:wall_id])
    if @wall
      @comments = @wall.comments
    end
    render :layout => false
  end
  
  def create_comment
    wall_id = params[:wall_id]
    comment = params[:comment]
    
    @wall = UserWall.find_by_id(params[:wall_id])
    
    if @wall
      obj_comment = Comment.new()
      obj_comment.comment = comment
      obj_comment.user = current_user
      @wall.comments << obj_comment
    end
    render :layout => false
  end
  
  def delete_comment
    comment_id = params[:comment_id]
    comment = Comment.find(comment_id)
    @wall = UserWall.find(comment.commentable_id)
    if comment && @wall
      comment.destroy if comment.user == current_user || @wall.user == current_user
    end
    render :layout => false
  end
  
  def delete_wall
    wall_id = params[:wall_id]
    wall = UserWall.find(wall_id)
    if wall
      wall.destroy if wall.user == current_user or wall.user_post == current_user
    end
    render :text => "Success"
  end
  
  def rate
    rating = params[:rating]
    @wall = UserWall.find(params[:post_id])
    @wall.rate rating.to_i, current_user
    @wall.save
    
    @text = "<div class='qashdU'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@wall.total_good}</a></div>"
    @text << "<div class='qashdD'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@wall.total_bad}</a></div>"
  end
  
  def link_image
  end
  
  def link_video
  end
  
  def link_music
  end
  
  def link_link
  end
  
  def match_making_box
    @user_id_post = params[:user_id_post]
    render :layout => false
  end
  
  def match_making_send
    content = params[:content]
    recipient = params[:recipient]
    user_id_post = params[:user_id_post]
    usr = User.find(user_id_post)
    list_ids = recipient.split(",")
    list_ids.each do |id|
      u = User.find(id)
      if u and u != usr
        message = Message.new
        message.sender = current_user
        message.recipient = u
        message.subject = "#{current_user.full_name} introduce #{usr.full_name} with you"
        message.body = content + "<br />" + "Click #{link_to "here", user_path(usr), :target => "blank"} to view profile of #{usr.full_name}"
        message.save
      end
    end
    
    render :text => "Success"
  end
  
  def passion_box
    @subject = params[:subject]
    @user_id = params[:user_id]
    @user_id_post = params[:user_id_post]
    render :layout => false
  end
  
  def submit_passion
    new_user_wall = UserWall.new
    new_user_wall.user_id_post = params[:user_id_post]
    new_user_wall.user_id = params[:user_id]
    
    content_of_wall = params[:content]
    
    new_user_wall.content = content_of_wall
    
    new_user_wall.save
    
    render :text => "Success"
  end
  
  def share_box
    @wall = UserWall.find(params[:wall_id])
    render :layout => false
  end
  
  def submit_share   
    w = UserWall.find(params[:wall_id])
    new_user_wall = UserWall.new
    new_user_wall.user_id_post = current_user.id
    new_user_wall.user_id = current_user.id
    
    new_user_wall.content = params[:message_subject]
    
    new_user_wall.save
    
    if w.user_wall_photo
      user_wall_photo = w.user_wall_photo
      new_user_wall.user_wall_photo = user_wall_photo
    end
    
    if w.user_wall_video
      user_wall_video = w.user_wall_video
      new_user_wall.user_wall_video = user_wall_video
    end
    
    if w.user_wall_music
      user_wall_music = w.user_wall_music
      new_user_wall.user_wall_music = user_wall_music
    end
    
    if w.user_wall_link
      user_wall_link = w.user_wall_link
      new_user_wall.user_wall_link = user_wall_link
    end
    
    new_user_wall.save
    
    render :text => "Success"
  end
  
  
  def attach_image
    link = params[:link]
    @err = false
    begin
      url = Domainatrix.parse(link)
      domain = get_domain(url)
      @user_wall_photo = UserWallPhoto.new
      @user_wall_photo.link = link
      @user_wall_photo.title = domain
      @user_wall_photo.sub_content = link
    rescue
      @err = true
    end
    render :layout => false
  end
  
  def attach_video
    link = params[:link]
    @err = false
    begin
      url = Domainatrix.parse(link)
      domain = get_domain(url)
      #Get thumbnail
      arr = link.match("[\\?&]v=([^&#]*)")
      vid = arr == nil ? link : arr[1]
      thumb = "http://img.youtube.com/vi/"+vid+"/2.jpg"
      
      @user_wall_video = UserWallVideo.new
      @user_wall_video.link = link
      @user_wall_video.thumb = thumb
      @user_wall_video.title = domain
      @user_wall_video.sub_content = link
    rescue
      @err = true
    end
    render :layout => false
  end
  
  def attach_music
    link = params[:link]
    @err = false
    begin
      url = Domainatrix.parse(link)
      domain = get_domain(url)
      @user_wall_music = UserWallMusic.new
      @user_wall_music.link = link
      @user_wall_music.title = domain
      @user_wall_music.sub_content = link
    rescue
      @err = true
    end
    render :layout => false
  end
  
  def attach_link
    link = params[:link]
    @err = false
    begin
      url = Domainatrix.parse(link)
      domain = get_domain(url)
      # Build an Hpricot object from a web page:
      hdrs = {"User-Agent"=>"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1", "Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
      my_html = ""
      open(link, hdrs).each {|s| my_html << s}
      @web_doc= Hpricot(my_html)
      @arr_img = []
      @web_doc.search("img").each{ |e| @arr_img << "http://" + domain + e.attributes['src'] if e.attributes['width'].to_i > 200 }
      image_link = ""
      image_link = @arr_img[0] if @arr_img.size > 0
      arr_p = []
      @web_doc.search("p").each{ |e| arr_p << e.inner_html.gsub(/<\/?[^>]*>/, "") }
      p = ""
      p = arr_p.max{|a, b| a.length <=> b.length} if arr_p.size > 0
      
      @user_wall_link = UserWallLink.new
      @user_wall_link.link = link
      @user_wall_link.image_link = image_link
      @user_wall_link.title = domain
      @user_wall_link.sub_content = p
    rescue
      @err = true
    end
    render :layout => false
  end
  
  def jplayer_music
    wall_id = params[:wall_id]
    wall = UserWall.find(wall_id)
    @user_wall_music = wall.user_wall_music
    render :layout => false
  end
  
  def jplayer_video
    wall_id = params[:wall_id]
    wall = UserWall.find(wall_id)
    @user_wall_video = wall.user_wall_video
    render :layout => false
  end
  
  def next_page_my_wall
    user_id = params[:user_id]
    user = User.find(user_id)
    @walls = user.my_walls.paginate :page => params[:page], :per_page => 10
    render :layout => false
  end
  
  def next_page_wall
    user_id = params[:user_id]
    user = User.find(user_id)
    @walls = user.user_walls.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    render :layout => false
  end
  
  private
  def get_domain(url)
    url.public_suffix
    url.domain
    url.subdomain
    domain = ""
    domain << url.subdomain + "." if url.subdomain != ""
    domain << url.domain + "." + url.public_suffix
  end
end

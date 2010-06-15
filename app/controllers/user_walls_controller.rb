# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UserWallsController < ApplicationController
  before_filter :login_required
  
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

  def link_image
  end

  def link_video
  end

  def link_music
  end

  def link_link
  end

  def attach_image
    link = params[:link]
    begin
      url = Domainatrix.parse(link)
      domain = get_domain(url)
      @user_wall_photo = UserWallPhoto.new
      @user_wall_photo.link = link
      @user_wall_photo.title = domain
      @user_wall_photo.sub_content = link
    rescue
      render :action => "error_link"
    end
  end

  def attach_video
    link = params[:link]
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
      render :action => "error_link"
    end
  end

  def attach_music
    link = params[:link]
    begin
      url = Domainatrix.parse(link)
      domain = get_domain(url)
      @user_wall_music = UserWallMusic.new
      @user_wall_music.link = link
      @user_wall_music.title = domain
      @user_wall_music.sub_content = link
    rescue
      render :action => "error_link"
    end
  end

  def attach_link
    link = params[:link]
    begin
      url = Domainatrix.parse(link)
      domain = get_domain(url)
      # Build an Hpricot object from a web page:
      hdrs = {"User-Agent"=>"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1", "Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
      my_html = ""
      open(link, hdrs).each {|s| my_html << s}
      @web_doc= Hpricot(my_html)
      @arr_img = []
      @web_doc.search("img").each{ |e| @arr_img << "http://" + domain + e.attributes['src'] }
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
      render :action => "error_link"
    end
  end

  def jplayer_music
    wall_id = params[:wall_id]
    wall = UserWall.find(wall_id)
    @user_wall_music = wall.user_wall_music
  end

  def jplayer_video
    wall_id = params[:wall_id]
    wall = UserWall.find(wall_id)
    @user_wall_video = wall.user_wall_video
  end

  def error_link
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

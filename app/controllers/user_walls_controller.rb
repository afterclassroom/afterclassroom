# � Copyright 2009 AfterClassroom.com -- All Rights Reserved
include ActionView::Helpers::UrlHelper
include ApplicationHelper
  
class UserWallsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  
  def create_wall
    user_wall_id = params[:user_wall_id]
    your_mind = params[:your_mind]
    @type = params[:type]
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
      if @user != current_user
        subject = "#{current_user.name} just posted on your Student Lounge."
        content = "Hello #{@user.name}, <br/>"
        content << "#{current_user.name} just posted something on your Student Lounge,  click <a href='#{user_student_lounges_url(@user)}' target='blank'>here</a> to see what's in it."
        send_notification(@user, subject, content, "posts_on_my_lounge")
      end
    end
    
    case @type
      when "student_lounge"
      @walls = current_user.walls_with_setting.paginate :page => params[:page], :per_page => 10
    else
      @walls = @user.my_walls.paginate :page => params[:page], :per_page => 10
    end
    
    respond_to do |format|
      format.html { redirect_to user_profiles_path(current_user) }
      format.js { 
        render :layout => false
      }
    end
  end
  
  def view_all_comments
    wall_id = params[:wall_id]
    post_id = params[:post_id]
    class_name = params[:class_name]
    @wall = UserWall.find(wall_id)
    @obj = eval(class_name).find(post_id)
    if @obj and @wall
      @comments = @obj.comments
    end
    render :layout => false
  end
  
  def create_comment
    wall_id = params[:wall_id]
    @wall = UserWall.find_by_id(params[:wall_id])
    
    comment = params[:comment]
    commentable_id = params[:commentable_id]
    commentable_type = params[:commentable_type]
    
    @obj = eval(commentable_type).find(commentable_id)
    
    if @obj and @wall
      obj_comment = Comment.new()
      obj_comment.comment = comment
      obj_comment.user = current_user
      @obj.comments << obj_comment
      @wall.update_attribute(:updated_at, Time.now)
      if @wall.user != current_user
        subject = "#{current_user.name} left comments on your Student Lounge"
        content = "Hello #{@wall.user.name},<br/>"
        content << "<p>#{current_user.name} just left comments on your Student Lounge, click <a href='#{user_student_lounges_url(@wall.user)}' target='blank'>here</a> to see what's in it.</p>"
        send_notification(@wall.user, subject, content, "comments_on_my_lounge")
      end
    end
    render :layout => false
  end
  
  def delete_comment
    wall_id = params[:wall_id]
    @wall = UserWall.find(wall_id)
    comment_id = params[:comment_id]
    comment = Comment.find(comment_id)
    comment_type = comment.commentable_type
    @obj = eval(comment_type).find(comment.commentable_id)
    if comment && @obj
      comment.destroy if comment.user == current_user || @obj.user == current_user
    end
    render :layout => false
  end
  
  def delete_wall
    wall_id = params[:wall_id]
    @wall = UserWall.find(wall_id)
    @user = @wall.user
    if @wall
      @wall.destroy if @wall.user == current_user or @wall.user_post == current_user
    end
    @walls = @user.user_walls.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    render :layout => false
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
    render :layout => false
  end
  
  def link_video
    render :layout => false
  end
  
  def link_music
    render :layout => false
  end
  
  def link_link
    render :layout => false
  end
  
  def match_making_box
    @user_id_post = params[:user_id_post]
    @user_post = User.find(@user_id_post)
    render :layout => false
  end
  
  def match_making_send
    content = params[:content]
    recipient = params[:recipient]
    user_id_post = params[:user_id_post]
    usr = User.find(user_id_post)
    list_ids = recipient.split(",")
    list_name = []
    list_ids.each do |id|
      u = User.find(id)
      if u and u != usr
        list_name << "<a href='#{user_url(u)}'>#{u.name}</a>"
        # Email, notification
        subject = "#{current_user.name} introduces someone special to you"
				content = "Hello #{usr.name}, <br/>"
        content << "<p><a href='#{user_url(current_user)}' target='blank'>#{current_user.name}</a> wants to introduce someone special to you."
        content << "#{user_url(current_user)} says: #{content}" if content
        content << "<br />" + "Click #{link_to "here", user_url(u), :target => "blank"} to see if you know #{u.name}</p>"
        send_notification(u, subject, content, "match_making")
      end
    end
    subject = "#{current_user.name} introduces some people special to you."
    content = "Hello #{usr.name},<br/>"
    content << "#{current_user.name} introduces some people special to you:<br/>" 
    content << list_name.join(", ")
    send_notification(usr, subject, content, "match_making")
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
    content_of_wall = params[:message_subject]
    content_of_wall << "<br/>" + params[:content] if params[:content]
    
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
      vid = get_video_id(link)
      thumb = "https://img.youtube.com/vi/"+vid+"/2.jpg"
      
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
      my_html = ""
      open(link, :proxy => nil).each {|s| my_html << s}
      @web_doc= Hpricot(my_html)
      @arr_img = []
      @web_doc.search("img").each{ |e| @arr_img << get_img_url(e.attributes['src'], domain) if e.attributes['width'].to_i > 90 }
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
    @wall = UserWall.find(wall_id)
    @musics = []
    if @wall.user_wall_music
      @musics << {:link => @wall.user_wall_music.link, :duration => "", :title => ""}
    elsif @wall.user_wall_post
      type = @wall.user_wall_post.post_type
      id = @wall.user_wall_post.post_id
      obj = eval(type).find(id)
      case type
        when "MusicAlbum"
          obj.musics.each do |m|
            @musics << {:link => m.music_attach.url, :duration => m.length_in_seconds, :title => (m.title == "" ? m.music_attach_file_name : m.title)}
          end
        when "Music"
          @musics << {:link => obj.music_attach.url, :duration => obj.length_in_seconds, :title => (obj.title == "" ? obj.music_attach_file_name : obj.title)}
      end
    end
    render :layout => false
  end
  
  def jplayer_video
    wall_id = params[:wall_id]
    @wall = UserWall.find(wall_id)
    if @wall.user_wall_video
      @link = @wall.user_wall_video.link
    elsif @wall.user_wall_post and @wall.user_wall_post.post_type == "Video"
      type = @wall.user_wall_post.post_type
      id = @wall.user_wall_post.post_id
      obj = eval(type).find(id)
      @link = obj.video_file.video_attach.url
    end
    render :layout => false
  end
  
    def jplayer_video_test
    wall_id = params[:wall_id]
    @wall = UserWall.find(wall_id)
    if @wall.user_wall_video
      @link = @wall.user_wall_video.link
    elsif @wall.user_wall_post and @wall.user_wall_post.post_type == "Video"
      type = @wall.user_wall_post.post_type
      id = @wall.user_wall_post.post_id
      obj = eval(type).find(id)
      @link = obj.video_file.video_attach.url
    end
    render :layout => false
  end
  
  def next_page_wall
    @type = params[:type]
    user_id = params[:user_id]
    user = User.find(user_id)
    @page = params[:page]
    case @type
      when "student_lounge"
      @walls = current_user.walls_with_setting.paginate :page => params[:page], :per_page => 10
    else
      @walls = user.my_walls.paginate :page => params[:page], :per_page => 10
    end
    render :layout => false
  end

	def block_wall
		@user_wall_id = params[:user_wall_id]
		user_wall_block = UserWallBlock.find_or_create_by_user_id_and_user_wall_id(current_user.id, @user_wall_id)
		render :layout => false
	end

	def block_user
		@user_wall_id = params[:user_wall_id]
		wall = UserWall.find(@user_wall_id)
		user_block = UserBlock.find_or_create_by_user_id_and_user_id_block(current_user.id, wall.user_post.id)
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
  
  def get_img_url(url, domain)
    if url.include?("http")
      url
    else
      "http://" + domain + url
    end
  end
end

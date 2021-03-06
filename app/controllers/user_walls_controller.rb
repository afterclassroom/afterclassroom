# � Copyright 2009 AfterClassroom.com -- All Rights Reserved
include ActionView::Helpers::UrlHelper
include ApplicationHelper
  
class UserWallsController < ApplicationController
  #before_filter RubyCAS::Filter::GatewayFilter
  #before_filter RubyCAS::Filter
  #before_filter :cas_user
  before_filter :login_required
  
  def create_wall
    user_wall_id = params[:user_wall_id]
    your_mind = params[:your_mind]
    @type = params[:type]
    @user = User.find(user_wall_id)
    unless @user.nil?
      @user_wall = UserWall.new
      @user_wall.user_id_post = current_user.id
      @user_wall.content = your_mind
      
      if params[:user_wall_photo]
        user_wall_photo = UserWallPhoto.new(params[:user_wall_photo])
        @user_wall.user_wall_photo = user_wall_photo
      end
      
      if params[:user_wall_video]
        user_wall_video = UserWallVideo.new(params[:user_wall_video])
        @user_wall.user_wall_video = user_wall_video
      end
      
      if params[:user_wall_music]
        user_wall_music = UserWallMusic.new(params[:user_wall_music])
        @user_wall.user_wall_music = user_wall_music
      end
      
      if params[:user_wall_link]
        user_wall_link = UserWallLink.new(params[:user_wall_link])
        @user_wall.user_wall_link = user_wall_link
      end
      
      @user_wall.save
      
      @user.user_walls << @user_wall
      @user.save
      if @user != current_user
        send_wall_notification(@user, current_user, @user_wall)
      end
    end
    
    render :layout => false
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
			update_user_wall_follow(@wall, current_user)
      if @wall.user != current_user
				# Send notification
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
    ct = params[:content]
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
        subject_f = "#{current_user.name} introduces someone special to you"
				content_f = "Hello #{u.name}, <br/>"
        content_f << "<p><a href='#{user_url(current_user)}' target='blank'>#{current_user.name}</a> wants to introduce someone special to you."
        content_f << "<br />" + "Click #{link_to "here", user_url(usr), :target => "blank"} to see if you know #{usr.name}</p>"
        send_notification(u, subject_f, content_f, "suggests_a_friend_to_me")
      end
    end
    subject = "#{current_user.name} introduces some people special to you."
    content = "Hello #{usr.name},<br/>"
    content << "#{current_user.name} introduces some people special to you:<br/>" 
    content << list_name.join(", ")
		content << "<br/><a href='#{user_url(current_user)}' target='blank'>#{current_user.name}</a> says: #{ct}" if ct
    send_notification(usr, subject, content, "suggests_a_friend_to_me")
    render :text => "Success"
  end
  
  def passion_box
    @subject = params[:subject]
    @user_id = params[:user_id]
    @user_id_post = params[:user_id_post]
    render :layout => false
  end
  
  def submit_passion
		user = User.find(params[:user_id])
    new_user_wall = UserWall.new
    new_user_wall.user_id_post = params[:user_id_post]
    new_user_wall.user_id = user.id
    content_of_wall = params[:message_subject]
    content_of_wall << "<br/>" + params[:content] if params[:content]
    
    new_user_wall.content = content_of_wall
    
    if new_user_wall.save
			send_wall_notification(user, current_user, new_user_wall) if user
		end
    
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
  
	def share_lounge
		wall_id = params[:wall_id]
		@wall = UserWall.find(wall_id)
		@wall = @wall.wall_parent if @wall.wall_parent
		render :layout => false
	end

	def submit_share_lounge
		your_mind = params[:your_mind]
		parent_id = params[:parent_id]
		wall_parent = UserWall.find(parent_id)
		receiver_id = params[:receiver_id]
		@user_wall = UserWall.new
    @user_wall.user_id_post = current_user.id
		if wall_parent.wall_parent
			@user_wall.parent_id = wall_parent.wall_parent.id
		else
			@user_wall.parent_id = wall_parent.id
		end
    @user_wall.content = your_mind
		if receiver_id != ""
			@user_wall.user_id = receiver_id
		else
			@user_wall.user_id = current_user.id
		end

		if @user_wall.save
			if receiver_id != ""
				user = User.find(receiver_id)
				send_wall_notification(user, current_user, @user_wall) if user
			end
		end
		
		render :layout => false
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
      @web_doc.search("img").each do |e|
				img_url = get_img_url(e.attributes['src'], domain)
				if e.attributes['width'] != ""
					@arr_img << img_url if e.attributes['width'].to_i > 90
				else
					begin
						i_url = URI.parse(img_url)
						Net::HTTP.start(i_url.host, i_url.port) {|http|
							resp = http.get(i_url.path)
							unless resp.nil?
								tempfile = Tempfile.new('tmp_img.jpg')
								File.open(tempfile.path, 'wb') do |f|
									f.write resp.body
								end
                image = MiniMagick::Image.open(tempfile.path)
                @arr_img << img_url if image[:width].to_i > 90
							end
						}
					rescue
						# Nothing
					end
				end
			end
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
  
  def jplayer_video_html5
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
  
  def jplayer_video5_html5
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
    @user = User.find(user_id)
    @page = params[:page]
    case @type
    when "student_lounge"
      @walls = current_user.walls_with_setting.paginate :page => params[:page], :per_page => 10
    else
      @walls = @user.my_walls.paginate :page => params[:page], :per_page => 10
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

	def send_wall_notification(user_wall, user_post, wall)
		subject = "#{user_post.name} just posted on your Student Lounge."
    content = "Hello #{user_wall.name}, <br/>"
    content << "#{user_post.name} just posted something on your Student Lounge,  click <a href='#{user_profiles_url(user_wall)}' target='blank'>here</a> to see what's in it."
    send_notification(user_wall, subject, content, "posts_on_my_lounge")
	end
end

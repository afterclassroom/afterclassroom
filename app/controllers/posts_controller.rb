# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostsController < ApplicationController
  include ApplicationHelper
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:report_abuse, :create_report_abuse, :download]
  before_filter :cas_user
  
  def create_comment
    comment = params[:comment]
    commentable_id = params[:commentable_id]
    commentable_type = params[:commentable_type]
    
    if comment && commentable_id && commentable_type
      @obj_comment = Comment.new()
      @obj_comment.comment = comment
      @obj_comment.commentable_id = commentable_id
      @obj_comment.commentable_type = commentable_type
      @obj_comment.user = current_user
      @obj_comment.save
      obj = eval(commentable_type).find(commentable_id)
      send_notification_when_comment(obj, @obj_comment)
    end
    render :layout => false
  end
  
  def create_comment_on_list
    comment = params[:comment]
    post_id = params[:post_id]
    @post = Post.find(post_id)
    
    if comment && @post
      @obj_comment = Comment.new()
      @obj_comment.comment = comment
      @obj_comment.commentable_id = @post.id
      @obj_comment.commentable_type = "Post"
      @obj_comment.user = current_user
      @obj_comment.save
      
      send_notification_when_comment(@post, @obj_comment)
    end
    render :layout => false
  end
  
  def view_all_comments
    post_id = params[:post_id]
    @post = Post.find(post_id)
    @comments = @post.comments
    render :layout => false
  end
  
  def comments_list
    class_name = params[:class_name]
    id = params[:id]
    @obj = eval(class_name).find(id)
    @comments = @obj.comments.paginate :page => params[:page], :per_page => 10
    render :layout => false
  end
  
  def delete_comment
    commentable_id = params[:post_id]
    id = params[:comment_id]
    comment = Comment.find_by_id_and_commentable_id(id, commentable_id)
    if comment.commentable.user == current_user or comment.user == current_user
      comment.destroy
    end
    render :text => comment.commentable.comments.size
  end
  
  def report_abuse
    @reported_id = params[:reported_id]
    @reported_type = params[:reported_type]
    render :layout => false
  end
  
  def create_report_abuse
    reported_id = params[:reported_id]
    reported_type = params[:reported_type]
    abuse_type_id = params[:abuse_type_id]
    abuse_content = params[:abuse_content]
    
    report_abuse = ReportAbuse.new
    report_abuse.reported_id = reported_id
    report_abuse.reported_type = reported_type
    report_abuse.report_abuse_category_id = abuse_type_id
    report_abuse.content = abuse_content
    report_abuse.reporter_id = current_user.id if current_user
    
    if report_abuse.save
      @str = "Thank you for your report, we will have someone from our security and ethnic department to look into your report and take action accordingly.<br/>"
      @str << "You will get notify once we take action."
    else
      @str = 'Error.'
    end
  end

	def remove_attach_file()
		post_id = params[:post_id]
		post = Post.find(post_id)
	  if post and post.user == current_user
			post.attach.clear if post.attach
		end 
		render :text => "Success"
	end
  
  def download
  end
  
  def send_notification_when_comment(obj, comnd)
    u = obj.user
    
    if u != current_user
      if comnd.commentable_type == "Post"
        post = Post.find(comnd.commentable_id)
        if post
          class_name = post.type_name
          school_id = post.school_id
          if class_name == "PostQa"
            # Objects cache
            Delayed::Job.enqueue(CacheCommentJob.new(class_name, nil, params))
            Delayed::Job.enqueue(CacheCommentJob.new(class_name, school_id, params))
          end
        end
        subject = "#{current_user.name} comment on your Post."
        content = "Click <a href='#{link_to_show_post(obj)}' target='blank'>here</a> to view more"
        send_notification(u, subject, content, "comments_on_my_posts")
      end
      
      if ["Photo", "PhotoAlbum", "Music", "MusicAlbum", "Video", "Story"].include?(comnd.commentable_type)
        case comnd.commentable_type
        when "Photo"
          subject = "#{current_user.name} comment on your Photo."
          content = "Click <a href='#{user_photo_url(u, obj)}' target='blank'>here</a> to view more"
          send_notification(u, subject, content, "comments_on_my_photos")
        when "PhotoAlbum"
          subject = "#{current_user.name} comment on your Photo Album."
          content = "Click <a href='#{show_album_user_photos_url(u, :photo_album_id => obj)}' target='blank'>here</a> to view more"
          send_notification(u, subject, content, "comments_on_my_photos")
        when "Music"
          subject = "#{current_user.name} comment on your Music."
          content = "Click <a href='#{user_music_url(u, obj)}' target='blank'>here</a> to view more"
          send_notification(u, subject, content, "comments_on_my_musics")
        when "MusicAlbum"
          subject = "#{current_user.name} comment on your Music Album."
          content = "Click <a href='#{play_list_user_musics_url(u, :music_album_id => obj)}' target='blank'>here</a> to view more"
          send_notification(u, subject, content, "comments_on_my_musics")
        when "Video"
          subject = "#{current_user.name} comment on your Video."
          content = "Click <a href='#{show_detail_video_user_url(obj.user, :video_id => obj.id)}' target='blank'>here</a> to view more"
          send_notification(u, subject, content, "comments_on_my_videos")
        when "Story"
          subject = "#{current_user.name} comment on your Story."
          content = "Click <a href='#{user_story_url(u, obj)}' target='blank'>here</a> to view more"
          send_notification(u, subject, content, "comments_on_my_share_a_story")
        end
      end
    end
  end
end

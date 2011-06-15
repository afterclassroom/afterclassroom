# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostsController < ApplicationController
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:rate_comment, :report_abuse, :create_report_abuse, :download]
  before_filter :cas_user
  #before_filter :login_required, :except => [:rate_comment, :report_abuse, :create_report_abuse, :download]
  
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
      u = obj.user
      
      if commentable_type == "Post"
        post = Post.find(commentable_id)
        if post
          class_name = post.type_name
          school_id = post.school_id
          if class_name == "PostQa"
            # Objects cache
            Delayed::Job.enqueue(CacheCommentJob.new(class_name, nil, params))
            Delayed::Job.enqueue(CacheCommentJob.new(class_name, school_id, params))
          end
        end
      end
      
      if ["Photo", "Music", "Story"].include?(commentable_type)
        case commentable_type
          when "Photo"
          subject = "#{current_user.name} comment on your Photo."
          content = "Click <a href='#{user_photo_url(u, obj)}' target='blank'>here</a> to view more"
          send_notification(u, subject, content, "comments_on_my_photo")
          when "Music"
          subject = "#{current_user.name} comment on your Music."
          content = "Click <a href='#{user_music_url(u, obj)}' target='blank'>here</a> to view more"
          send_notification(u, subject, content, "comments_on_my_music")
          when "Story"
          subject = "#{current_user.name} comment on your Story."
          content = "Click <a href='#{user_story_url(u, obj)}' target='blank'>here</a> to view more"
          send_notification(u, subject, content, "comments_on_my_story")
          
        end
      end
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

      if @post
        class_name = @post.type_name
        school_id = @post.school_id
        if class_name == "PostQa"
          # Objects cache
          Delayed::Job.enqueue(CacheCommentJob.new(class_name, nil, params))
          Delayed::Job.enqueue(CacheCommentJob.new(class_name, school_id, params))
        end
      end
    end
    render :layout => false
  end
  
  def view_all_comments
    post_id = params[:post_id]
    @post = Post.find(post_id)
    @comments = @post.comments
    render :layout => false
  end
  
  def delete_comment
    post_id = params[:post_id]
    comment_id = params[:comment_id]
    post = Post.find(post_id)
    comment = post.comments.find(comment_id)
    if post.user == current_user or comment.user == current_user
      comment.destroy
    end
    render :text => post.comments.size
  end
  
  def rate_comment
    rating = params[:rating]
    @comnt = Comment.find(params[:comment_id])
    @comnt.rate rating.to_i
    @text = "<div class='AsDcomRe1'><a href='javascript:;'>#{@comnt.total_good}</a></div>"
    @text << "<div class='AsDcomRe2'><a href='javascript:;'>#{@comnt.total_bad}</a></div>"
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
  
  def download
  end
end

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
      obj = @obj_comment.find_commentable(commentable_type, commentable_id)
      user = obj.user
      if ["Photo", "Music", "UserWall"].include?(commentable_type)
        case commentable_type
          when "Photo"
            subject = "#{current_user.name} comment on your Photo."
            content = "Click <a href='#{show_user_photos_url(user, obj)}' target='blank'>here</a> to view more"
            send_notification(user, subject, content, "comments_on_my_photo")
          when "Music"
            subject = "#{current_user.name} comment on your Music."
            content = "Click <a href='#{show_user_musics_url(user, obj)}' target='blank'>here</a> to view more"
            send_notification(user, subject, content, "comments_on_my_music")
          when "Story"
            subject = "#{current_user.name} comment on your Story."
            content = "Click <a href='#{show_user_stories_url(user, obj)}' target='blank'>here</a> to view more"
            send_notification(user, subject, content, "comments_on_my_story")
        end
      end
    end
    render :layout => false
  end
  
  def delete_comment
    comment_id = params[:comment_id]
    if comment_id
      comment = Comment.find(comment_id)
      comment.destroy if comment
    end
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
      str = %Q'
        Thank you for your report, we will have someone from our security and ethnic department to look into your report and take action accordingly.<br/>
        You will get notify once we take action.
      '
    else
      str = 'Error.'
    end
    
    render :text => str
  end
  
  def download
  end
end

# � Copyright 2009 AfterClassroom.com � All Rights Reserved
class AjaxNotLoginController < ApplicationController
  layout false
  
  def show_comment
    show = params[:show]
    show ||= "0"
    post_id = params[:post_id]
    post = Post.find(post_id)
    get_comments(post, show)
    
    render :layout => false
  end
  
  def rate_comment
    rating = params[:rating]
    @comnt = Comment.find(params[:comment_id])
    @comnt.rate rating.to_i
    @text = "<div class='AsDcomRe1'><a href='javascript:;'>#{@comnt.total_good}</a></div>"
    @text << "<div class='AsDcomRe2'><a href='javascript:;'>#{@comnt.total_bad}</a></div>"
  end
end

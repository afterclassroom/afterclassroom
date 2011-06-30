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
  
  private
  
  def get_comments(post, show)
    @comments = []
    case show
      when "0"
      @comments = post.comments
      when "1"
      @comments = post.comments
      when "2"
      @comments = post.comments.find(:all, :order => "created_at DESC")
      when "3"
      arr_comnt = []
      post.comments.each do |c|
        arr_comnt << {:obj => c, :total_good => c.total_good}
      end
      arr_comnt.sort_by { |c| -c[:total_good] }.each do |d|
        @comments << d[:obj]
      end
    end
  end
end

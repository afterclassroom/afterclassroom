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
    @text = "<div class='qashdU'><a href='javascript:;'>#{@comnt.total_good}</a></div>"
    @text << "<div class='qashdD'><a href='javascript:;'>#{@comnt.total_bad}</a></div>"
  end
  
  def rate_comment_action
    rating = params[:rating]
    @comnt = Comment.find(params[:comment_id])
    @comnt.rate rating.to_i
    @text = "<div class='AsDcomRe1'><a href='javascript:;'>#{@comnt.total_good}</a></div>"
    @text << "<div class='AsDcomRe2'><a href='javascript:;'>#{@comnt.total_bad}</a></div>"
  end
  
  def view_results
    post_awareness_id = params[:post_awareness_id]
    post_awareness = PostAwareness.find(post_awareness_id)
    total_support = post_awareness.total_support.to_i
    total_notsupport = post_awareness.total_notsupport.to_i
    chart = GoogleChart.new
    chart.type = :pie
    chart.data = [total_support, total_notsupport]
    
    #reuse and change size, set labels for big chart
    str = "Reliable"
    str_not = "Not Reliable"
    if post_awareness.awareness_type.label == "take_action_now"
      str = "Support"
      str_not = "Not Support"
    end
    chart.labels = [str,str_not]
    chart.height = 300
    chart.width = 550
    @chart_url = chart.to_url
    render :layout => false
  end

  def view_press_info_detail
    @pr = PressInfo.find(params[:pr_id])
  end

	def view_career_detail
    @pr = Career.find(params[:pr_id])
  end
end

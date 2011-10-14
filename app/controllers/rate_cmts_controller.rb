class RateCmtsController < ApplicationController
  def load_bk_like
    @post = Post.find(params[:post_id])
    @rating_texts = @post.rating_texts.order('created_at DESC').paginate(:page => 1, :per_page => params[:str_perpage])
    render :layout => false
  end
  def add_like_cmt
    @post = Post.find(params[:post_id])
    @cmt = RatingText.new()
    @cmt.user = current_user
    @cmt.post = @post
    @cmt.rated_type = "PostBook"
    @cmt.rating = 1
    @cmt.content = params[:cmt_cnt]
    @cmt.save
    
    render :layout => false
  end
end

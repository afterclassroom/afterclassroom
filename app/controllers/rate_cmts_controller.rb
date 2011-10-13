class RateCmtsController < ApplicationController
  def load_bk_like
    @post = Post.find(params[:post_id])
    render :layout => false
  end
  def add_cmt
    render :layout => false
  end
end

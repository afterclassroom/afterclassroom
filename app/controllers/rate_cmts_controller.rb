class RateCmtsController < ApplicationController
  def load_bk_like
    @post = Post.find(params[:post_id])
    render :layout => false
  end
  def add_like_cmt
    @post_id = params[:post_id]
    @cmt = RatingText.new()
    @cmt.rater_id = current_user.id
    @cmt.rated_id = params[:post_id]
    @cmt.rated_type = "PostBook"
    @cmt.rating = 1
    @cmt.content = params[:cmt_cnt]
    @cmt.save
    puts "=="
    puts "== v"
    puts "== #{params[:post_id]}"
    puts "== content"
    puts "== a == #{params[:cmt_cnt]}"
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    render :layout => false
  end
end

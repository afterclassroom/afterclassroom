class RateCmtsController < ApplicationController
  def load_bk_like
    @post = Post.find(params[:post_id])
    render :layout => false
  end
  def add_like_cmt
    @post_id = params[:post_id]
    puts "=="
    puts "== v"
    puts "== #{params[:post_id]}"
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
    puts "=="
    puts "=="
    render :layout => false
  end
end

# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Admin::PostsController < ApplicationController
  require_role :admin
  layout 'admin'

  def index
    @post_cat = PostCategory.find(:all)
    @all_posts = Post.paginated_post_management_admin(params)
  end

  def with_type
    @post_cat = PostCategory.find(:all)
    @all_posts = Post.paginated_post_management_admin(params)
    render :layout => false
  end

  def delete
    post = Post.find(params[:id])
    post.destroy if post
    redirect_to admin_posts_url()
  end
end

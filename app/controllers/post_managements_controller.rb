class PostManagementsController < ApplicationController
  
  before_filter :login_required

  def index
    @all_posts = Post.with_user_id(current_user.id)
    @post_cat = PostCategory.find(:all)
    category = params[:category]
  end

  def with_type
    @post_cat = PostCategory.find(:all)
    category = params[:category]
    @all_posts = nil

    if category == "Category"
      @all_posts = PostCategory.find(:all)
    else
      @all_posts = current_user.get_posts_with_type(category)
    end

    render :layout => false
  end
  
end

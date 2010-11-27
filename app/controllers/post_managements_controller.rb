class PostManagementsController < ApplicationController
  
  before_filter :login_required

  def index
    @all_posts = Post.with_user_id(current_user.id)
    @post_cat = PostCategory.find(:all)
    
  end
end

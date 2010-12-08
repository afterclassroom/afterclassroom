class PostManagementsController < ApplicationController
  
  before_filter :login_required

  def index
    @all_posts = Post.paginated_post_management(params,"ASC",current_user.id)

    @post_cat = PostCategory.find(:all)
    category = params[:category]
  end

  def with_type
    @post_cat = PostCategory.find(:all)
    @category = params[:category]
    @all_posts = nil

    if @category == "Category"
      @all_posts = Post.paginated_post_management(params,"ASC",current_user.id)
    else
      @all_posts = current_user.get_posts_with_type(@category).paginate(:page => params[:page], :per_page => 3, :order => "created_at DESC")
    end

    render :layout => false
  end
  
end

class PostManagementsController < ApplicationController
  
  before_filter :login_required

  def index
    @all_posts = Post.paginated_post_management(params, current_user.id)

    @post_cat = PostCategory.find(:all)
    category = params[:category]
    @sort = "DESC"
  end

  def with_type
    @post_cat = PostCategory.find(:all)
    @category = params[:category]
    @all_posts = nil

    @sort = "DESC"
    if params[:sort]!= nil
      @sort = params[:sort]
    end
    
    cur_page = 1

    if params[:page] != nil && params[:page] != ""
      cur_page = params[:page]
    end

    if @category == "Category"
      puts "category category category category category "
      puts "category category category category category "
      puts "category category category category category "
      puts "category category category category category "
      puts "category category category category category "
      puts "category category category category category "
      @all_posts = Post.paginated_post_management(params,current_user.id)
    else
      @all_posts = current_user.get_posts_with_type(@category).paginate(:page => cur_page, :per_page => 3, :order => "created_at "+@sort)
    end

    render :layout => false
  end

  def search_post
    @post_cat = PostCategory.find(:all)
    @all_posts = Post.searchpost(params,current_user.id)

    render :layout => false
  end
  
end

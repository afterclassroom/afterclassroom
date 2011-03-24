class PostManagementsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required

  def index
    @post_cat = PostCategory.find(:all)
    @category = params[:category] if params[:category]
    @sort = "DESC"
    @all_posts = Post.paginated_post_management(params, current_user.id)
    
    cur_page = 1
    
    if @category == "" &&
      @all_posts = Post.paginated_post_management(params, current_user.id)
    else
      @all_posts = current_user.get_posts_with_type(@category).paginate(:page => cur_page, :per_page => 10, :order => "created_at "+@sort)
    end
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
      @all_posts = Post.paginated_post_management(params,current_user.id)
    else
      @all_posts = current_user.get_posts_with_type(@category).paginate(:page => cur_page, :per_page => 10, :order => "created_at "+@sort)
    end

    render :layout => false
  end
  
end

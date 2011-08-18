class PostManagementsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required

  def index
    @post_cat = PostCategory.find(:all)
    @category = params[:category]
    @sort = "DESC"
    @query = params[:search][:query] if params[:search].present? and params[:search][:query].present?
    cur_page = 1
    
    if @category.nil? or @category == "" or @category == "Category"
      @all_posts = Post.paginated_post_management(params, current_user.id).results
    else
      @all_posts = current_user.get_posts_with_type_and_sort(@category, @sort).paginate(:page => cur_page, :per_page => 10)
    end
  end

  def with_type
    @post_cat = PostCategory.find(:all)
    @category = params[:category]
    @all_posts = nil

    @sort = "DESC"
    @sort = params[:sort] if params[:sort]
    
    cur_page = 1

    if params[:page] != nil && params[:page] != ""
      cur_page = params[:page]
    end

    @all_posts = current_user.get_posts_with_type_and_sort(@category, @sort).paginate(:page => cur_page, :per_page => 10)

    render :layout => false
  end
  
  def delete_all
    category = params[:category]
    list_ids = params[:list_ids]
    list_ids = list_ids.slice(0..list_ids.length - 2)
    ids = list_ids.split(", ")
    posts = current_user.posts.find(:all, :conditions => ["id IN(#{ids.join(", ")})"])
    if posts.size > 0
      posts.each do |abl|
        abl.favorites.destroy_all if abl.favorites.size > 0
        if abl.post_assignments
          del_post_wall(abl.post_assignments)
        end
        if abl.post_projects
          del_post_wall(abl.post_projects)
        end
        if abl.post_tests
          del_post_wall(abl.post_tests)
        end
        if abl.post_exams
          del_post_wall(abl.post_exams)
        end
        if abl.post_events
          del_post_wall(abl.post_events)
        end
        if abl.post_qas
          del_post_wall(abl.post_qas)
        end
        if abl.post_tutors
          del_post_wall(abl.post_tutors)
        end
        if abl.post_books
          del_post_wall(abl.post_books)
        end
        if abl.post_jobs
          del_post_wall(abl.post_jobs)
        end
        if abl.post_foods
          del_post_wall(abl.post_foods)
        end
        if abl.post_myxes
          del_post_wall(abl.post_myxes)
        end
        if abl.post_awarenesses
          del_post_wall(abl.post_awarenesses)
        end
        if abl.post_housings
          del_post_wall(abl.post_housings)
        end
        if abl.post_teamups
          del_post_wall(abl.post_teamups)
        end
        if abl.post_exam_schedules
          del_post_wall(abl.post_exam_schedules)
        end
        abl.destroy
      end
    end
    redirect_to(user_post_managements_url(current_user, :category => category))
  end
  
end

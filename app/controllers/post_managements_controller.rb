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
        if abl.post_assignment
          abl.post_assignment.destroy
          del_post_wall(abl.post_assignment)
        end
        if abl.post_project
          abl.post_project.destroy
          del_post_wall(abl.post_project)
        end
        if abl.post_test
          abl.post_test.destroy
          del_post_wall(abl.post_test)
        end
        if abl.post_exam
          abl.post_exam.destroy
          del_post_wall(abl.post_exam)
        end
        if abl.post_event
          abl.post_event.destroy
          del_post_wall(abl.post_event)
        end
        if abl.post_qa
          abl.post_qa.destroy
          del_post_wall(abl.post_qa)
        end
        if abl.post_tutor
          abl.post_tutor.destroy
          del_post_wall(abl.post_tutor)
        end
        if abl.post_book
          abl.post_book.destroy
          del_post_wall(abl.post_book)
        end
        if abl.post_job
          abl.post_job.destroy
          del_post_wall(abl.post_job)
        end
        if abl.post_food
          abl.post_food.destroy
          del_post_wall(abl.post_food)
        end
        if abl.post_myx
          abl.post_myx.destroy
          del_post_wall(abl.post_myx)
        end
        if abl.post_awareness
          abl.post_awareness.destroy
          del_post_wall(abl.post_awareness)
        end
        if abl.post_housing
          abl.post_housing.destroy
          del_post_wall(abl.post_housing)
        end
        if abl.post_teamup
          abl.post_teamup.destroy
          del_post_wall(abl.post_teamup)
        end
        if abl.post_exam_schedule
          abl.post_exam_schedule.destroy
          del_post_wall(abl.post_exam_schedule)
        end
      end
    end
    redirect_to(user_post_managements_url(current_user, :category => category))
  end
  
end

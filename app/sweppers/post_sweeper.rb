class PostSweeper < ActionController::Caching::Sweeper
  observe PostAssignment, PostTest, PostProject, PostExam, PostQa, PostTutor, PostBook, PostJob, PostParty, PostAwareness, PostHousing, PostTeamup, PostMyx, PostFood, PostExamSchedule, PostEvent
  
  def after_save(post)
    clear_posts_cache(post)
  end
  
  def after_update(post)
    clear_posts_cache(post)
  end
  
  def after_destroy(post)
    clear_posts_cache(post)
  end
  
  def clear_posts_cache(post)
    class_name = post.class.name
    case class_name
      when "PostAssignment"
      expire_action :controller => 'post_assignments', :action => 'index'
      expire_action :controller => 'post_assignments', :action => 'show', :id => post
      when "PostProject"
      expire_action :controller => 'post_projects', :action => 'index'
      expire_action :controller => 'post_projects', :action => 'show', :id => post
      when "PostTest"
      expire_action :controller => 'post_tests', :action => 'index'
      expire_action :controller => 'post_tests', :action => 'show', :id => post
      when "PostExam"
      expire_action :controller => 'post_exams', :action => 'index'
      expire_action :controller => 'post_exams', :action => 'show', :id => post
      when "PostEvent"
      expire_action :controller => 'post_events', :action => 'index'
      expire_action :controller => 'post_events', :action => 'show', :id => post
      when "PostQa"
      expire_action :controller => 'post_qas', :action => 'index'
      expire_action :controller => 'post_qas', :action => 'show', :id => post
      when "PostTutor"
      expire_action :controller => 'post_tutors', :action => 'index'
      expire_action :controller => 'post_tutors', :action => 'show', :id => post
      when "PostBook"
      expire_action :controller => 'post_books', :action => 'index'
      expire_action :controller => 'post_books', :action => 'show', :id => post
      when "PostJob"
      expire_action :controller => 'post_jobs', :action => 'index'
      expire_action :controller => 'post_jobs', :action => 'show', :id => post
      when "PostFood"
      expire_action :controller => 'post_foods', :action => 'index'
      expire_action :controller => 'post_foods', :action => 'show', :id => post
      when "PostParty"
      expire_action :controller => 'post_parties', :action => 'index'
      expire_action :controller => 'post_parties', :action => 'show', :id => post
      when "PostMyx"
      expire_action :controller => 'post_myxes', :action => 'index'
      expire_action :controller => 'post_myxes', :action => 'show', :id => post
      when "PostAwareness"
      expire_action :controller => 'post_awarenesses', :action => 'index'
      expire_action :controller => 'post_awarenesses', :action => 'show', :id => post
      when "PostHousing"
      expire_action :controller => 'post_housings', :action => 'index'
      expire_action :controller => 'post_housings', :action => 'show', :id => post
      when "PostTeamup"
      expire_action :controller => 'post_teamups', :action => 'index'
      expire_action :controller => 'post_teamups', :action => 'show', :id => post
      when "PostExamSchedule"
      expire_action :controller => 'post_exam_schedules', :action => 'index'
      expire_action :controller => 'post_exam_schedules', :action => 'show', :id => post
    end
    expire_fragment "browser_by_subject_#{class_name}"
    expire_fragment :select_department_post
    expire_fragment :select_department_quick_post
    expire_fragment :option_select_department
  end
end
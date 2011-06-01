class PostSweeper < ActionController::Caching::Sweeper
  observe PostAssignment, PostTest, PostProject, PostExam, PostQa, PostTutor, PostBook, PostJob, PostParty, PostAwareness, PostHousing, PostTeamup, PostMyx, PostFood, PostExamSchedule, PostEvent
  
  def after_save(p)
    clear_posts_cache(p)
  end
  
  def after_update(p)
    clear_posts_cache(p)
  end
  
  def after_destroy(p)
    clear_posts_cache(p)
  end
  
  def clear_posts_cache(p)
    class_name = p.class.name
    school_id = p.post.school_id
    case class_name
      when "PostAssignment"
      expire_action :controller => 'post_assignments', :action => 'index'
      expire_action :controller => 'post_assignments', :action => 'show', :id => p
      when "PostProject"
      expire_action :controller => 'post_projects', :action => 'index'
      expire_action :controller => 'post_projects', :action => 'show', :id => p
      when "PostTest"
      expire_action :controller => 'post_tests', :action => 'index'
      expire_action :controller => 'post_tests', :action => 'show', :id => p
      when "PostExam"
      expire_action :controller => 'post_exams', :action => 'index'
      expire_action :controller => 'post_exams', :action => 'show', :id => p
      when "PostEvent"
      expire_action :controller => 'post_events', :action => 'index'
      expire_action :controller => 'post_events', :action => 'show', :id => p
      when "PostQa"
      expire_action :controller => 'post_qas', :action => 'index'
      expire_action :controller => 'post_qas', :action => 'show', :id => p
      when "PostTutor"
      expire_action :controller => 'post_tutors', :action => 'index'
      expire_action :controller => 'post_tutors', :action => 'show', :id => p
      when "PostBook"
      expire_action :controller => 'post_books', :action => 'index'
      expire_action :controller => 'post_books', :action => 'show', :id => p
      when "PostJob"
      expire_action :controller => 'post_jobs', :action => 'index'
      expire_action :controller => 'post_jobs', :action => 'show', :id => p
      when "PostFood"
      expire_action :controller => 'post_foods', :action => 'index'
      expire_action :controller => 'post_foods', :action => 'show', :id => p
      when "PostParty"
      expire_action :controller => 'post_parties', :action => 'index'
      expire_action :controller => 'post_parties', :action => 'show', :id => p
      when "PostMyx"
      expire_action :controller => 'post_myxes', :action => 'index'
      expire_action :controller => 'post_myxes', :action => 'show', :id => p
      when "PostAwareness"
      expire_action :controller => 'post_awarenesses', :action => 'index'
      expire_action :controller => 'post_awarenesses', :action => 'show', :id => p
      when "PostHousing"
      expire_action :controller => 'post_housings', :action => 'index'
      expire_action :controller => 'post_housings', :action => 'show', :id => p
      when "PostTeamup"
      expire_action :controller => 'post_teamups', :action => 'index'
      expire_action :controller => 'post_teamups', :action => 'show', :id => p
      when "PostExamSchedule"
      expire_action :controller => 'post_exam_schedules', :action => 'index'
      expire_action :controller => 'post_exam_schedules', :action => 'show', :id => p
    end
    expire_fragment "browser_by_subject_#{class_name}_"
    expire_fragment "browser_by_subject_#{class_name}_#{school_id}"
    expire_fragment "select_department_post_#{school_id}"
    expire_fragment "select_department_quick_post_"
    expire_fragment "select_department_quick_post_#{school_id}"
    expire_fragment "option_select_department_"
    expire_fragment "option_select_department_#{school_id}"
  end
end
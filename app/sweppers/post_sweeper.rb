class PostSweeper < ActionController::Caching::Sweeper
  observe Post
  
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
    case post.type_name
      when "PostAssignment"
      expires_cache :controller => 'post_assignments', :action => 'index'
      expires_cache :controller => 'post_assignments', :action => 'show', :id => post
      when "PostProject"
      expires_cache :controller => 'post_projects', :action => 'index'
      expires_cache :controller => 'post_projects', :action => 'show', :id => post
      when "PostTest"
      expires_cache :controller => 'post_tests', :action => 'index'
      expires_cache :controller => 'post_tests', :action => 'show', :id => post
      when "PostExam"
      expires_cache :controller => 'post_exams', :action => 'index'
      expires_cache :controller => 'post_exams', :action => 'show', :id => post
      when "PostEvent"
      expires_cache :controller => 'post_events', :action => 'index'
      expires_cache :controller => 'post_events', :action => 'show', :id => post
      when "PostQa"
      expires_cache :controller => 'post_qas', :action => 'index'
      expires_cache :controller => 'post_qas', :action => 'show', :id => post
      when "PostTutor"
      expires_cache :controller => 'post_tutors', :action => 'index'
      expires_cache :controller => 'post_tutors', :action => 'show', :id => post
      when "PostBook"
      expires_cache :controller => 'post_books', :action => 'index'
      expires_cache :controller => 'post_books', :action => 'show', :id => post
      when "PostJob"
      expires_cache :controller => 'post_jobs', :action => 'index'
      expires_cache :controller => 'post_jobs', :action => 'show', :id => post
      when "PostFood"
      expires_cache :controller => 'post_foods', :action => 'index'
      expires_cache :controller => 'post_foods', :action => 'show', :id => post
      when "PostParty"
      expires_cache :controller => 'post_parties', :action => 'index'
      expires_cache :controller => 'post_parties', :action => 'show', :id => post
      when "PostMyx"
      expires_cache :controller => 'post_myxes', :action => 'index'
      expires_cache :controller => 'post_myxes', :action => 'show', :id => post
      when "PostAwareness"
      expires_cache :controller => 'post_awarenesses', :action => 'index'
      expires_cache :controller => 'post_awarenesses', :action => 'show', :id => post
      when "PostHousing"
      expires_cache :controller => 'post_housings', :action => 'index'
      expires_cache :controller => 'post_housings', :action => 'show', :id => post
      when "PostTeamup"
      expires_cache :controller => 'post_teamups', :action => 'index'
      expires_cache :controller => 'post_teamups', :action => 'show', :id => post
      when "PostExamSchedule"
      expires_cache :controller => 'post_exam_schedules', :action => 'index'
      expires_cache :controller => 'post_exam_schedules', :action => 'show', :id => post
    end
  end
end
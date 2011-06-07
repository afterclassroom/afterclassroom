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
    
    # Objects cache
    Delayed::Job.enqueue(CacheJob.new(p.id, class_name, nil, params))
    Delayed::Job.enqueue(CacheJob.new(p.id, class_name, school_id, params))
    
    # Fragment cache
    expire_fragment "browser_by_subject_#{class_name}_"
    expire_fragment "browser_by_subject_#{class_name}_#{school_id}"
    expire_fragment "recents_#{class_name}_#{school_id}"
    expire_fragment "select_department_post_#{school_id}"
    expire_fragment "select_department_quick_post_"
    expire_fragment "select_department_quick_post_#{school_id}"
    expire_fragment "option_select_department_"
    expire_fragment "option_select_department_#{school_id}"
  end
end
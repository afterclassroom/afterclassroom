class CacheJob < Struct.new(:id, :class_name, :school_id, :params)
  include ActiveSupport
  def perform
    list = ["", "30", "90", "180", "270", "365"]
    case class_name
      when "PostAssignment"
        post = eval(class_name).find(id).post
        Rails.cache.write("more_like_this_department#{post.department_id}_school_year#{post.school_year}", PostAssignment.paginated_post_more_like_this(params, post))
        Rails.cache.write("index_#{class_name}_#{school_id}_year_department_over", PostAssignment.paginated_post_conditions_with_option(params, school_id))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostAssignment.paginated_post_conditions_with_option(params, school_id))
        end
      when "PostProject"
        post = eval(class_name).find(id).post
        Rails.cache.write("more_like_this_department#{post.department_id}_school_year#{post.school_year}", PostProject.paginated_post_more_like_this(params, post))
        Rails.cache.write("index_#{class_name}_#{school_id}_year_department_over", PostProject.paginated_post_conditions_with_option(params, school_id))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostProject.paginated_post_conditions_with_option(params, school_id))
        end
      when "PostTest"
        post = eval(class_name).find(id).post
        Rails.cache.write("more_like_this_department#{post.department_id}_school_year#{post.school_year}", PostTest.paginated_post_more_like_this(params, post))
        Rails.cache.write("index_#{class_name}_#{school_id}_year_department_over", PostTest.paginated_post_conditions_with_option(params, school_id))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostTest.paginated_post_conditions_with_option(params, school_id))
        end
      when "PostExam"
        post = eval(class_name).find(id).post
        Rails.cache.write("more_like_this_department#{post.department_id}_school_year#{post.school_year}", PostExam.paginated_post_more_like_this(params, post))
        Rails.cache.write("index_#{class_name}_#{school_id}_year_department_over", PostExam.paginated_post_conditions_with_option(params, school_id))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostExam.paginated_post_conditions_with_option(params, school_id))
        end
      when "PostEvent"
        post = eval(class_name).find(id).post
        Rails.cache.write("index_#{class_name}_type#{post.post_event.event_type_id}_#{school_id}", PostEvent.paginated_post_conditions_with_option(params, school_id, post.post_event.event_type_id))
      when "PostQa"
        post = eval(class_name).find(id).post
        Rails.cache.write("index_#{class_name}_typeasked_#{school_id}_year_department_over", PostQa.paginated_post_conditions_with_option(params, school_id, "asked"))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_typeasked_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostQa.paginated_post_conditions_with_option(params, school_id, "asked"))
        end
      when "PostTutor"
        post = eval(class_name).find(id).post
        Rails.cache.write("index_#{class_name}_type#{post.post_tutor.tutor_type_id}_#{school_id}_year_department_over", PostTutor.paginated_post_conditions_with_option(params, school_id, post.post_tutor.tutor_type_id))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_type#{post.tutor_type_id}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostTutor.paginated_post_conditions_with_option(params, school_id, post.tutor_type_id))
        end
      when "PostBook"
        post = eval(class_name).find(id).post
        Rails.cache.write("index_#{class_name}_type#{post.post_book.book_type_id}_#{school_id}_year_department_over", PostBook.paginated_post_conditions_with_option(params, school_id, post.post_book.book_type_id))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_type#{post.book_type_id}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostBook.paginated_post_conditions_with_option(params, school_id, post.book_type_id))
        end
      when "PostJob"
        post = eval(class_name).find(id).post
        Rails.cache.write("index_#{class_name}_type#{post.post_job.job_type_id}_#{school_id}_year_department_over", PostJob.paginated_post_conditions_with_option(params, school_id, post.post_job.job_type_id))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_type#{post.job_type_id}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostJob.paginated_post_conditions_with_option(params, school_id, post.job_type_id))
        end
      when "PostFood"
        Rails.cache.write("index_#{class_name}_status_#{school_id}", PostFood.paginated_post_conditions_with_option(params, school_id, ""))
      when "PostParty"
        Rails.cache.write("index_#{class_name}_status_#{school_id}", PostParty.paginated_post_conditions_with_option(params, school_id, ""))
      when "PostMyx"
        post = eval(class_name).find(id).post
        Rails.cache.write("index_#{class_name}_status_#{school_id}_year_department_over", PostMyx.paginated_post_conditions_with_option(params, school_id, ""))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_status_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostMyx.paginated_post_conditions_with_option(params, school_id, ""))
        end
      when "PostAwareness"
        post = eval(class_name).find(id).post
        Rails.cache.write("index_#{class_name}_type#{post.post_awareness.awareness_type_id}_#{school_id}_year_department_over", PostAwareness.paginated_post_conditions_with_option(params, school_id, post.post_awareness.awareness_type_id))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_type#{post.awareness_type_id}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostAwareness.paginated_post_conditions_with_option(params, school_id, post.awareness_type_id))
        end
      when "PostHousing"
        post = eval(class_name).find(id).post
        Rails.cache.write("index_#{class_name}_category_#{school_id}", PostHousing.paginated_post_conditions_with_option(params, school_id, nil))
        if post.housing_categories.size > 0
          post.housing_categories.each do |cat|
            Rails.cache.write("index_#{class_name}_category#{cat.id}_#{school_id}", PostHousing.paginated_post_conditions_with_option(params, school_id, cat.id))
          end
        end
      when "PostTeamup"
        post = eval(class_name).find(id).post
        Rails.cache.write("index_#{class_name}_category#{post.post_teamup.teamup_category_id}_#{school_id}_year_department_over", PostTeamup.paginated_post_conditions_with_option(params, school_id, post.post_teamup.teamup_category_id))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_category#{post.post_teamup.teamup_category_id}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostTeamup.paginated_post_conditions_with_option(params, school_id, post.post_teamup.teamup_category_id))
        end
      when "PostExamSchedule"
        post = eval(class_name).find(id).post
        Rails.cache.write("index_#{class_name}_type#{post.post_exam_schedule.type_name}_#{school_id}_year_department_over", PostExamSchedule.paginated_post_conditions_with_option(params, school_id, post.post_exam_schedule.type_name))
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_type#{post.post_exam_schedule.type_name}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostExamSchedule.paginated_post_conditions_with_option(params, school_id, post.post_exam_schedule.type_name))
        end
    end
  end
end
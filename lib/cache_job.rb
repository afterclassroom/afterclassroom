class CacheJob < Struct.new(:id, :class_name, :school_id, :params)
  include ActiveSupport
  def perform
    case class_name
      when "PostAssignment"
        post = eval(class_name).find(id).post
        Rails.cache.write("more_like_this_department(#{post.department_id})_school_year(#{post.school_year})", PostAssignment.paginated_post_more_like_this(params, post))
        Rails.cache.write("index_#{class_name}_#{school_id}", PostAssignment.paginated_post_conditions_with_option(params, school_id))
      when "PostProject"
        post = eval(class_name).find(id).post
        Rails.cache.write("more_like_this_department(#{post.department_id})_school_year(#{post.school_year})", PostProject.paginated_post_more_like_this(params, post))
        Rails.cache.write("index_#{class_name}_#{school_id}", PostProject.paginated_post_conditions_with_option(params, school_id))
      when "PostTest"
        post = eval(class_name).find(id).post
        Rails.cache.write("more_like_this_department(#{post.department_id})_school_year(#{post.school_year})", PostTest.paginated_post_more_like_this(params, post))
        Rails.cache.write("index_#{class_name}_#{school_id}", PostTest.paginated_post_conditions_with_option(params, school_id))
      when "PostExam"
        post = eval(class_name).find(id).post
        Rails.cache.write("more_like_this_department(#{post.department_id})_school_year(#{post.school_year})", PostExam.paginated_post_more_like_this(params, post))
        Rails.cache.write("index_#{class_name}_#{school_id}", PostExam.paginated_post_conditions_with_option(params, school_id))
      when "PostEvent"
        post = eval(class_name).find(id)
        Rails.cache.write("index_#{class_name}_type#{post.event_type_id}_#{school_id}", PostEvent.paginated_post_conditions_with_option(params, school_id, post.event_type_id))
      when "PostQa"
        Rails.cache.write("index_#{class_name}_typeasked_#{school_id}", PostQa.paginated_post_conditions_with_option(params, school_id, "asked"))
      when "PostTutor"
        post = eval(class_name).find(id)
        Rails.cache.write("index_#{class_name}_type#{post.tutor_type_id}_#{school_id}", PostTutor.paginated_post_conditions_with_option(params, school_id, post.tutor_type_id))
      when "PostBook"
        post = eval(class_name).find(id)
        Rails.cache.write("index_#{class_name}_type#{post.book_type_id}_#{school_id}", PostBook.paginated_post_conditions_with_option(params, school_id, post.book_type_id))
      when "PostJob"
        post = eval(class_name).find(id)
        Rails.cache.write("index_#{class_name}_type#{post.job_type_id}_#{school_id}", PostJob.paginated_post_conditions_with_option(params, school_id, post.job_type_id))
      when "PostFood"
        Rails.cache.write("index_#{class_name}_status_#{school_id}", PostFood.paginated_post_conditions_with_option(params, school_id, ""))
      when "PostParty"
        Rails.cache.write("index_#{class_name}_status_#{school_id}", PostParty.paginated_post_conditions_with_option(params, school_id, ""))
      when "PostMyx"
        Rails.cache.write("index_#{class_name}_status_#{school_id}", PostMyx.paginated_post_conditions_with_option(params, school_id, ""))
      when "PostAwareness"
        post = eval(class_name).find(id)
        Rails.cache.write("index_#{class_name}_type#{post.awareness_type_id}_#{school_id}", PostAwareness.paginated_post_conditions_with_option(params, school_id, post.awareness_type_id))
      when "PostHousing"
        post = eval(class_name).find(id)
        Rails.cache.write("index_#{class_name}_category_#{school_id}", PostHousing.paginated_post_conditions_with_option(params, school_id, nil))
        if post.housing_categories.size > 0
          post.housing_categories.each do |cat|
            Rails.cache.write("index_#{class_name}_category#{cat.id}_#{school_id}", PostHousing.paginated_post_conditions_with_option(params, school_id, cat.id))
          end
        end
      when "PostTeamup"
        post = eval(class_name).find(id)
        Rails.cache.write("index_#{class_name}_category#{post.teamup_category_id}_#{school_id}", PostTeamup.paginated_post_conditions_with_option(params, school_id, post.teamup_category_id))
      when "PostExamSchedule"
        post = eval(class_name).find(id)
        Rails.cache.write("index_#{class_name}_type#{post.type_name}_#{school_id}", PostExamSchedule.paginated_post_conditions_with_option(params, school_id, post.type_name))
    end
  end
end
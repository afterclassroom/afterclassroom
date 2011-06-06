class CacheJob < Struct.new(:id, :class_name, :school_id, :params)
  include ActiveSupport
  def perform
    case class_name
      when "PostAssignment"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostAssignment.paginated_post_conditions_with_option(params, school_id))
      when "PostProject"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostProject.paginated_post_conditions_with_option(params, school_id))
      when "PostTest"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostTest.paginated_post_conditions_with_option(params, school_id))
      when "PostExam"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostExam.paginated_post_conditions_with_option(params, school_id))
      when "PostEvent"
        post = eval(class_name).find(id)
        Rails.cache.write("index_#{class_name}_type#{post.event_type_id}_#{school_id}", PostEvent.paginated_post_conditions_with_option(params, school_id, post.event_type_id))
      when "PostQa"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostQa.paginated_post_conditions_with_option(params, school_id, "asked"))
      when "PostTutor"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostTutor.paginated_post_conditions_with_option(params, school_id, post.tutor_type_id))
      when "PostBook"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostBook.paginated_post_conditions_with_option(params, school_id, post.book_type_id))
      when "PostJob"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostJob.paginated_post_conditions_with_option(params, school_id, post.job_type_id))
      when "PostFood"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostFood.paginated_post_conditions_with_option(params, school_id, ""))
      when "PostParty"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostParty.paginated_post_conditions_with_option(params, school_id, ""))
      when "PostMyx"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostMyx.paginated_post_conditions_with_option(params, school_id, ""))
      when "PostAwareness"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostAwareness.paginated_post_conditions_with_option(params, school_id, post.awareness_type_id))
      when "PostHousing"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostHousing.paginated_post_conditions_with_option(params, school_id, ""))
        if post.post_housings.housing_categories.size > 0
          post.post_housings.housing_categories.each do |cat|
            Rails.cache.write("index_#{class_name}_#{school_id}", PostHousing.paginated_post_conditions_with_option(params, school_id, cat.id))
          end
        end
      when "PostTeamup"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostTeamup.paginated_post_conditions_with_option(params, school_id, post.teamup_category_id))
      when "PostExamSchedule"
        Rails.cache.write("index_#{class_name}_#{school_id}", PostExamSchedule.paginated_post_conditions_with_option(params, school_id, post.type_name))
    end
  end
end
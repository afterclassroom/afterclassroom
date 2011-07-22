class CacheRattingJob < Struct.new(:id, :class_name, :school_id, :status, :params)
  include ActiveSupport
  def perform
    list = ["", "30", "90", "180", "270", "365"]
    case class_name
      when "PostMyx"
        post = eval(class_name).find(id)
        list.each do |over|
          params[:department] = post.department_id
          params[:year] = post.school_year
          params[:over] = over
          Rails.cache.write("index_#{class_name}_status#{status}_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", eval(class_name).paginated_post_conditions_with_option(params, school_id, status))
      end
    else
      Rails.cache.write("index_#{class_name}_status#{status}_#{school_id}", eval(class_name).paginated_post_conditions_with_option(params, school_id, status))
    end
  end
end
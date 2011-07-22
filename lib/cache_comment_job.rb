class CacheCommentJob < Struct.new(:id, :class_name, :school_id, :params)
  include ActiveSupport
  def perform
    list = ["", "30", "90", "180", "270", "365"]
    post = eval(class_name).find(id).post
    list.each do |over|
      params[:department] = post.department_id
      params[:year] = post.school_year
      params[:over] = over
      Rails.cache.write("index_#{class_name}_typeasked_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostQa.paginated_post_conditions_with_option(params, school_id, "asked"))
      Rails.cache.write("index_#{class_name}_typeanswered_#{school_id}_year#{post.school_year}_department#{post.department_id}_over#{over}", PostQa.paginated_post_conditions_with_option(params, school_id, "answered"))
    end
  end
end
class CacheCommentJob < Struct.new(:class_name, :school_id, :params)
  include ActiveSupport
  def perform
    Rails.cache.write("index_#{class_name}_typeasked_#{school_id}", PostQa.paginated_post_conditions_with_option(params, school_id, "asked"))
    Rails.cache.write("index_#{class_name}_typeanswered_#{school_id}", PostQa.paginated_post_conditions_with_option(params, school_id, "answered"))
  end
end
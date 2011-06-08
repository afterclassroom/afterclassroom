class CacheRattingJob < Struct.new(:class_name, :school_id, :status, :params)
  include ActiveSupport
  def perform
    Rails.cache.write("index_#{class_name}_status#{status}_#{school_id}", eval(class_name).paginated_post_conditions_with_option(params, school_id, status))
  end
end
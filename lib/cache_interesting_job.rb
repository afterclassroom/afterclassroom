class CacheInterestingJob < Struct.new(:class_name, :school_id, :params)
  include ActiveSupport
  def perform
    Rails.cache.write("interesting_#{class_name}_#{school_id}", eval(class_name).paginated_post_conditions_with_interesting(params, school_id))
  end
end
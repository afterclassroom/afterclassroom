module Viewable
  protected
  def update_view_count(viewable)
    stack_name = Inflector.underscore(viewable.class).downcase

    if cookies[stack_name].nil?
      cookies[stack_name] = [viewable.id.to_s]      
      viewable.update_attribute(:count_view, viewable.count_view + 1)
    elsif !cookies[stack_name].include?(viewable.id.to_s)
      cookies[stack_name] << viewable.id.to_s
      viewable.update_attribute(:count_view, viewable.count_view + 1)
    else
      #already viewed it, do nothing
      return false
    end
  end
end
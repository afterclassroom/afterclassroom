# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class FavoritesController < ApplicationController
  layout 'student_lounge'
  
  #before_filter RubyCAS::Filter::GatewayFilter
  #before_filter RubyCAS::Filter
  #before_filter :cas_user
  before_filter :login_required

  def add_to_favorite
    add()
  end

  def add_to_favorite_in_detail
    add()
  end
  
  private
  
  def add
    @item_id = params[:item_id]
    type = params[:type]
    item = object_with_type(type, @item_id)
    current_user.has_favorite(item)
    @f_size = item.favoriting_users.size
    # clear interesting cache
    if type == "Post" && @f_size > 0
      class_name = item.type_name
      school_id = item.school_id
      # Objects cache
      if ["PostAssignment", "PostProject", "PostTest", "PostExam", "PostQa"].include?(class_name)
        Delayed::Job.enqueue(CacheInterestingJob.new(class_name, nil, params))
        Delayed::Job.enqueue(CacheInterestingJob.new(class_name, school_id, params))
      end
      # Fragment cache
      expire_fragment "interesting_#{class_name}_#{school_id}"
    end
  end
end

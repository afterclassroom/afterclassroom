# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class FavoritesController < ApplicationController
  layout 'student_lounge'
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required

  def add_to_favorite
    @item_id = params[:item_id]
    type = params[:type]
    item = object_with_type(type, @item_id)
    current_user.has_favorite(item)
    @f_size = item.favoriting_users.size
  end

  def add_to_favorite_in_detail
    @item_id = params[:item_id]
    type = params[:type]
    item = object_with_type(type, @item_id)
    current_user.has_favorite(item)
    @f_size = item.favoriting_users.size
  end
  
end

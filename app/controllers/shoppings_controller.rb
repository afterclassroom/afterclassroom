# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ShoppingsController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required

  def mainpage
    @categories = Shoppingcategory.find(:all)

    @friends_id = []
		for friend in current_user.user_friends
			@friends_id << friend.id
		end

    params[:page] = "1"
    params[:subid] = "1" #first-time open page, sub-category = Musical Instrument
    @listallitems = SellingItem.paginated_item_conditions_with_friend(params,@friends_id)

    @list_recent = SellingItem.paginated_item_conditions_with_recent(params)

  end

  def cat_nav
    @categories = Shoppingcategory.find(:all)
    @friends_id = []
		for friend in current_user.user_friends
			@friends_id << friend.id
		end

    params[:page] = 1 #:page=1 is applied for will_paginate 
    @listallitems = SellingItem.paginated_item_conditions_with_friend(params,@friends_id)
  end

  def recentitems
    @list_recent = SellingItem.paginated_item_conditions_with_recent(params)
    render :layout => false
  end

  def friendads 
    @friends_id = []
		for friend in current_user.user_friends
			@friends_id << friend.id
		end
    @listallitems = SellingItem.paginated_item_conditions_with_friend(params,@friends_id)
    render :layout => false
  end

  def shoppingdetail
    
  end


end

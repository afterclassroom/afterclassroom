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
    
    @listallitems = SellingItem.friend_item(@friends_id)
    #PHAN CONG VIEC TIEP THEO CAN LAM DOI VOI MUC NAY LA`:
    #1> DA LO.C DUOC CAC SELLING_ITEM THUOC VE FRIEND CUA CURRENT_USER
    #2> CAN LO.C LAI 1 LAN NUA DE NHAN DUOC CAC SELLING_ITEM THUOC VE SELECTED_SUB_CATEGORY

    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
    puts params[:sub_category_name]
  end

  def shoppingdetail
    
  end


end
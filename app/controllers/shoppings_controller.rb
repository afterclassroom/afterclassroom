# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ShoppingsController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required

  def mainpage
    @categories = Shoppingcategory.find(:all)
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
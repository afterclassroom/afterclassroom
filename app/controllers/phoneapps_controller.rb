# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PhoneappsController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required

  def recommendapp

    @appcategory = Phoneappcategory.find(:all)
    @iphonedata = Phoneapplication.search('1', '1')
    @pageIapp = Phoneapplication.alliphoneapp().size / 5
    
  end

  def iphonepage

    curpage = params[:page]
    if curpage == nil
      curpage = 1
    end

    iphone = '1'
    @iphonedata = Phoneapplication.search(iphone, curpage)
    render :layout => false

  end
  def phonelounge
    
    if params[:id]
      id = params[:id]

      @pa = Phoneapplication.find(id)

    end
  end

  def info
    if params[:id]
      id = params[:id]

      @pa = Phoneapplication.find(id)

    end
  end

  def favorite
    if params[:id]
      id = params[:id]

      @pa = Phoneapplication.find(id)

    end
    
  end

end

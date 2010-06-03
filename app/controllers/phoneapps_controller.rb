# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PhoneappsController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required

  def recommendapp

    @appcategory = Phoneappcategory.find(:all)
    @iphonedata = Phoneapplication.search('1', '1')
    @bberrydata = Phoneapplication.search('2', '1')
    @googleappdata = Phoneapplication.search('3', '1')
    @pageIapp = Phoneapplication.alliphoneapp().size / 5
    @pagebberry = Phoneapplication.allbberryapp().size / 5
    @pagegoogleapp = Phoneapplication.allgoogleapp().size / 5

    
  end

  def iphonepage
    curpage = params[:page]
    if curpage == nil
      curpage = 1
    end

    @iphonedata = Phoneapplication.search('1', curpage)
    render :layout => false
  end

  def bberrypage
    curpage = params[:page]
    if curpage == nil
      curpage = 1
    end

    @bberrydata = Phoneapplication.search('2', curpage)
    render :layout => false
  end

  def googleapppage
    curpage = params[:page]
    if curpage == nil
      curpage = 1
    end

    @g_appdata = Phoneapplication.search('3', curpage)
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

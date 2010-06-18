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
    @allapps = Phoneapplication.allapp('1')
    @pageallapps = Phoneapplication.allapp('').size / 5

    
  end

  def pagingphoneapps
    @allapps = Phoneapplication.allapp(params[:page]) #this variable store the data for willpaginate
    @pageallapps = Phoneapplication.allapp('').size / 5 #this variable store the number of total page
    @curpage = (params[:page])
    render :layout => false
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

  def phoneappstab
    render :layout => false
  end

  def populartab
    curpage = 0
    if (params[:page] == nil || params[:page]== '')
      curpage = '1'
    else
      curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end

    @popularap = Phoneapplication.popularapp(curpage)#this variable is used to store the specific data for a specifict page
    @noOfPages = Phoneapplication.popularapp('all').size/5#this variable is used to calculate the total no of page
    @currentPage = curpage

    render :layout => false
  end

  def verifiedtab
    curpage = 0
    if (params[:page] == nil || params[:page]== '')
      curpage = '1'
    else
      curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end

    @verifiedap = Phoneapplication.verifiedapp(curpage)#this variable is used to store the specific data for a specifict page

    @noOfPages = Phoneapplication.verifiedapp('all').size/5#this variable is used to calculate the total no of page

    @currentPage = curpage

    render :layout => false
  end

  def recentlyaddedtab

    curpage=0
    if (params[:page] == nil || params[:page]== '')
      curpage = '1'
    else
      curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end
    
    @recentap = Phoneapplication.recentlyaddedapp(curpage)#this variable is used to store the specific data for a specifict page
    
    @noOfPages = Phoneapplication.recentlyaddedapp('all').size/5#this variable is used to calculate the total no of page

    @currentPage = curpage
    
    render :layout => false
  end

  def seealltab
    render :layout => false
  end
end
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

    datasize = Phoneapplication.allapp('').size
    @pageallapps = datasize / 5

    if (datasize % 5 > 0)
      @pageallapps = @pageallapps + 1
    end

    
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
      @pa.popular_rank = @pa.popular_rank + 1
      if @pa.save
        #do something
        puts "update successfully" + @pa.popular_rank.to_s
      end

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
    @curpage = 0
    if (params[:page] == nil || params[:page]== '')
      @curpage = '1'
    else
      @curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end

    @allapps = Phoneapplication.allapp(@curpage) #this variable store the data for willpaginate

    datasize = Phoneapplication.allapp('').size
    @pageallapps = datasize / 5#this variable store the number of total page

    if (datasize % 5 > 0)
      @pageallapps = @pageallapps + 1
    end



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

    datasize = Phoneapplication.popularapp('all').size
    @noOfPages = datasize / 5#this variable is used to calculate the total no of page

    if (datasize % 5 > 0)
      @noOfPages = @noOfPages + 1
    end


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

    datasize = Phoneapplication.verifiedapp('all').size
    @noOfPages = datasize / 5#this variable is used to calculate the total no of page

    if (datasize % 5 > 0)
      @noOfPages = @noOfPages + 1
    end


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
    
    datasize = Phoneapplication.recentlyaddedapp('all').size
    @noOfPages = datasize / 5#this variable is used to calculate the total no of page

    if (datasize % 5 > 0)
      @noOfPages = @noOfPages + 1
    end

    @currentPage = curpage
    
    render :layout => false
  end

  def seealltab
    @curpage = 0
    if (params[:page] == nil || params[:page]== '')
      @curpage = '1'
    else
      @curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end

    @allapps = Phoneapplication.allapp(@curpage) #this variable store the data for willpaginate
    datasize = Phoneapplication.allapp('').size
    @pageallapps = datasize / 5#this variable is used to calculate the total no of page

    if (datasize % 5 > 0)
      @pageallapps = @pageallapps + 1
    end


    render :layout => false
  end
end

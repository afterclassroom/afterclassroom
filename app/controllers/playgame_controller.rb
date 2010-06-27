# © Copyright 2009 AfterClassroom.com — All Rights Reserved

class PlaygameController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required

  def gameslounge
  end

  def info

  end

  def favorite
    
  end

  def recommendgame
    @allgame = Gameapp.allapp('1')
    datasize = Gameapp.allapp('').size
    @pageallgame = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @pageallgame = @pageallgame + 1
    end
  end

  def pagingallgame
    @allgame = Gameapp.allapp(params[:page]) #this variable store the data for willpaginate
    datasize = Gameapp.allapp('').size
    @pageallgame = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @pageallgame = @pageallgame + 1
    end
    @curpage = (params[:page])
    
    render :layout => false
  end

  def gametab
    @allgame = Gameapp.allapp('1')
    render :layout => false
  end

  def populartab
    curpage = 0
    if (params[:page] == nil || params[:page]== '')
      curpage = '1'
    else
      curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end
    
    @popularap = Gameapp.popularapp(curpage)#this variable is used to store the specific data for a specifict page
    render :layout => false
  end

  def verifiedtab
    curpage = 0
    if (params[:page] == nil || params[:page]== '')
      curpage = '1'
    else
      curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end

    @verifiedap = Gameapp.verifiedapp(curpage)#this variable is used to store the specific data for a specifict page

    render :layout => false
  end
  
  def recentlyaddedtab
    curpage=0
    if (params[:page] == nil || params[:page]== '')
      curpage = '1'
    else
      curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end
    @recentap = Gameapp.recentlyaddedapp(curpage)#this variable is used to store the specific data for a specifict page
    render :layout => false

  end

  def seealltab
    @allgame = Gameapp.allapp('1')
    render :layout => false
  end

end

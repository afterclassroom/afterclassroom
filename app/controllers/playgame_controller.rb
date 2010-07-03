# © Copyright 2009 AfterClassroom.com — All Rights Reserved

class PlaygameController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required

  def gameslounge
    if params[:id]
      id = params[:id]

      @gapp = Gameapp.find(id)

    end
  end

  def info
    if params[:id]
      id = params[:id]

      @gapp = Gameapp.find(id)

    end
  end

  def favorite
    if params[:id]
      id = params[:id]

      @gapp = Gameapp.find(id)

    end
  end

  def recommendgame
    @allgame = Gameapp.allapp('1')
    datasize = Gameapp.allapp('').size
    @pageallgame = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @pageallgame = @pageallgame + 1
    end
  end

  def pagingallgame #this action is applied for pagination when user first-time browse recommend-game
    @allgame = Gameapp.allapp(params[:page]) #this variable store the data for willpaginate
    datasize = Gameapp.allapp('').size
    @pageallgame = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @pageallgame = @pageallgame + 1
    end
    @curpage = (params[:page])
    
    render :layout => false
  end

  def gametab #this action is called when user click on game-tab on the View
    curpage = 0
    if (params[:page] == nil || params[:page]== '')
      curpage = '1'
    else
      curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end
    
    @allgame = Gameapp.allapp(curpage)
    datasize = Gameapp.allapp('').size
    @pageallgame = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @pageallgame = @pageallgame + 1
    end
    @curpage = (params[:page])

    render :layout => false
  end

  def populartab
    curpage = 0
    if (params[:page] == nil || params[:page]== '')
      curpage = '1'
    else
      curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end
    datasize = Gameapp.popularapp('all').size
    @totalpage = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @totalpage = @totalpage + 1
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

    datasize = Gameapp.verifiedapp('all').size
    @totalpage = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @totalpage = @totalpage + 1
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
    datasize = Gameapp.recentlyaddedapp('all').size
    @totalpage = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @totalpage = @totalpage + 1
    end
    @recentap = Gameapp.recentlyaddedapp(curpage)#this variable is used to store the specific data for a specifict page
    render :layout => false

  end

  def seealltab
    curpage = 0
    if (params[:page] == nil || params[:page]== '')
      curpage = '1'
    else
      curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end

    @allgame = Gameapp.allapp(curpage)


    datasize = Gameapp.allapp('').size
    @pageallgame = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @pageallgame = @pageallgame + 1
    end
    @curpage = (params[:page])

    render :layout => false
  end

end

# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class LearningtoolsController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required

  def recommendtool
    @alltool = Toolapp.allapp('1')
    datasize = Toolapp.allapp('').size
    @pagealltool = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @pagealltool = @pagealltool + 1
    end
  end

  def pagingalltool #this action is applied for pagination when user first-time browse recommend-tool
    @alltool = Toolapp.allapp(params[:page]) #this variable store the data for willpaginate
    datasize = Toolapp.allapp('').size
    @pagealltool = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @pagealltool = @pagealltool + 1
    end
    @curpage = (params[:page])

    render :layout => false
  end
  
  def tooltab
    @curpage = 0
    if (params[:page] == nil || params[:page]== '')
      @curpage = '1'
    else
      @curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end

    @alltool = Toolapp.allapp(@curpage)
    datasize = Toolapp.allapp('').size
    @pagealltool = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @pagealltool = @pagealltool + 1
    end

    render :layout => false
  end
  def populartab
    @curpage = 0
    if (params[:page] == nil || params[:page]== '')
      @curpage = '1'
    else
      @curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end
    datasize = Toolapp.popularapp('all').size
    @totalpage = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @totalpage = @totalpage + 1
    end

    @popularap = Toolapp.popularapp(@curpage)#this variable is used to store the specific data for a specifict page
    render :layout => false
  end
  def verifiedtab
    @curpage = 0
    if (params[:page] == nil || params[:page]== '')
      @curpage = '1'
    else
      @curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end

    datasize = Toolapp.verifiedapp('all').size
    @totalpage = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @totalpage = @totalpage + 1
    end

    @verifiedap = Toolapp.verifiedapp(@curpage)#this variable is used to store the specific data for a specifict page

    render :layout => false
  end
  def recentlyaddedtab
    @curpage=0
    if (params[:page] == nil || params[:page]== '')
      @curpage = '1'
    else
      @curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end
    datasize = Toolapp.recentlyaddedapp('all').size
    @totalpage = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @totalpage = @totalpage + 1
    end
    @recentap = Toolapp.recentlyaddedapp(@curpage)#this variable is used to store the specific data for a specifict page
    render :layout => false
  end
  def seealltab
    @curpage = 0
    if (params[:page] == nil || params[:page]== '')
      @curpage = '1'
    else
      @curpage = params[:page] #this variable is used to store the current page that willpaginate return
    end

    @alltool = Toolapp.allapp(@curpage)


    datasize = Toolapp.allapp('').size
    @pagealltool = datasize / 5 #this variable store the number of total page
    if (datasize % 5 > 0)
      @pagealltool = @pagealltool + 1
    end
    render :layout => false
  end

  def learninglounge
    if params[:id]
      id = params[:id]

      @pa = Toolapp.find(id)
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
      @pa = Toolapp.find(id)
    end
  end

  def favorite
    if params[:id]
      id = params[:id]
      @pa = Toolapp.find(id)
    end
  end



end
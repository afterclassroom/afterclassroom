# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PhoneappsController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required

  def recommendapp

    @appcategory = Phoneappcategory.find(:all)

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

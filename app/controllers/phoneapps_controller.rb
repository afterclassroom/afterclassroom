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

      puts "================================"
      puts "================================"
      puts "================================"
      puts "================================"
      puts "================================"
      puts "================================"
      puts "================================"
      puts "================================"
      puts "id ==== "+id
      puts "name === "+@pa.name
    end
  end

  def info
  end

  def favorite
    
  end

end

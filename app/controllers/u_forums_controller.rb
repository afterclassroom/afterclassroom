class UForumsController < ApplicationController

  layout 'student_lounge'

  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  
  def view_detail
    
  end

  def new
    @ufo = Ufo.new()
  end

  def save
    @ufo = Ufo.new(params[:ufo])
    @ufo.user = current_user
    if @ufo.save
      flash[:notice] = "Your topic was successfully submitted."
      @ufo = Ufo.new()
      render :action => "new"
    else
      flash[:notice] = "Failed to create new topic."
      render :action => "new"
    end
  end

  def dft_stgs
    render :layout => false
  end


  def save_setting
    #user = current_user
    #type_setting = refer to constant
    #share_to :: refer to constant (this is the value of option selected on page dialog
    str = params[:shareto]
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "=="
    puts "== v = "
    puts "==val = #{str}"


    render :layout => false 
  end

end

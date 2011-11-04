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
    #ufo_defaults
    default_setting = UfoDefault.find_or_create_by_user_id_and_share_to_index(current_user.id, params[:shareto])


    default_setting.user = current_user
    default_setting.share_to_index = params[:shareto]
    default_setting.save




    # type = params[:type]
    # val = params[:value]
    
    # pr = PrivateSetting.find_or_create_by_user_id_and_type_setting(current_user.id, type)
    # pr.share_to = val.to_i
    # pr.save
    # hash = Hash[OPTIONS_SETTING.map {|x| [x[0], x[1]]}]
    # render :text => hash.index(val.to_i)


    render :layout => false 
  end

end

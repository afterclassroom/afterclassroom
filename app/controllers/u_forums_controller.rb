class UForumsController < ApplicationController

  layout 'student_lounge'

  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  

  def show
    @ufo = Ufo.find(params[:id])
  end

  def new
    @ufo = Ufo.new()
    @txt = "display custom setting in cross check with default setting here"
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
    default_setting = UfoDefault.find_or_create_by_user_id(current_user.id)
    default_setting.share_to_index = params[:shareto]
    default_setting.post_lounge = params[:postlounge]
    default_setting.save

    render :layout => false 
  end

  def save_custom
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "===="
    puts "====a"
    puts "==== shareto == #{params[:shareto]}"
    puts "==== lounge == #{params[:postlounge]}"

    render :layout => false 
  end

  def index
    @ufos = current_user.ufos
  end

end

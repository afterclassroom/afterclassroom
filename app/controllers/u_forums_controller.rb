class UForumsController < ApplicationController

  layout 'student_lounge'

  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  

  def show
    @ufo = Ufo.find(params[:id])
    @ufo_cmt = UfoCmt.new()
  end

  def new
    @ufo = Ufo.new()
  end

  def save
    @ufo = Ufo.new(params[:ufo])
    @ufo.user = current_user
    if @ufo.save
      flash[:notice] = "Your topic was successfully submitted."

      custom_setting = UfoCustom.find_or_create_by_ufo_id(@ufo.id)
      custom_setting.share_to_index = params[:ufo_setting]
      custom_setting.post_lounge = params[:lounge_setting]
      custom_setting.save

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
    custom_setting = UfoCustom.find_or_create_by_ufo_id(params[:id])
    custom_setting.share_to_index = params[:shareto]
    custom_setting.post_lounge = params[:postlounge]
    custom_setting.save



    render :layout => false 
  end

  def index
    @ufos = current_user.ufos
  end

  def save_cmt
    objufo = Ufo.find(params[:ufo_id])

    ufo_cmt = UfoCmt.new(params[:ufo_cmt])
    ufo_cmt.user = current_user
    ufo_cmt.ufo_id = objufo.id
    ufo_cmt.save

    render :layout => false 
  end

end

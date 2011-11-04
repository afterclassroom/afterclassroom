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
    render :layout => false 
  end

end

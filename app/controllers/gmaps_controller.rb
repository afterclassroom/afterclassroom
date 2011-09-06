# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class GmapsController < ApplicationController
  def index
    @address = params[:address]
    @html = params[:html]
    render :layout => false
  end
end

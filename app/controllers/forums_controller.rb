# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ForumsController < ApplicationController

  def index  
    @text = "test from forum"
    # @forums = Forum.find(:all)
    @forums = Forum.find(:all).paginate(:page => params[:page], :per_page => 8, :order => "created_at")
  end

end

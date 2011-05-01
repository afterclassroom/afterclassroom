# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ForumsController < ApplicationController

  def index  
    @text = "test from forum"
    @forums = Forum.find(:all)
  end

end

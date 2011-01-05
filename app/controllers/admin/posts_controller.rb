# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Admin::PostsController < ApplicationController
  require_role :admin
  layout 'admin'

  def index
  end
end

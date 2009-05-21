# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Admin::DashboardController < ApplicationController
  require_role :admin
  layout 'admin'
  
  def index
  end
end

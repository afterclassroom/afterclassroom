# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class DashboardController < ApplicationController
  # GET /
  # The default dashboard
  def index
    @type_name = "Assignments"
    @new_post_path = "/posts/new?type_name=#{@type_name}"
    @assignments = Post.find_all_by_type_name("Assignments", :limit => 5, :order => "created_at DESC")
    @jobs = Post.has_jobs :limit => 5
    @books = Post.has_books :limit => 5
    @projects = Post.find_all_by_type_name("Projects", :limit => 5, :order => "created_at DESC")
  end
end

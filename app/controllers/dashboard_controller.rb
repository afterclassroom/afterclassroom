# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class DashboardController < ApplicationController
  # GET /
  # The default dashboard
  def index
    arr_path =[
      post_assignments_path,
      post_projects_path,
      post_tests_path,
      post_assignments_path,
      post_qas_path,
      post_tutors_path,
      post_books_path,
      post_jobs_path,
      post_foods_path,
      post_parties_path,
      post_myxes_path,
      post_awarenesses_path,
      post_housings_path,
      post_teamups_path,
      post_assignments_path
    ]
    redirect_to arr_path[rand(arr_path.size)]
  end
end

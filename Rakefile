# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'sunspot/rails/tasks'
require 'jammit'

#Jammit.package!

include Rake::DSL

Afterclassroom::Application.load_tasks

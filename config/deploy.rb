set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require "whenever/capistrano"

#############################################################
# Application
#############################################################
set :application, "Afterclassroom"

#############################################################
# Settings
#############################################################
ssh_options[:paranoid] = true
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
default_run_options[:pty] = true # required for svn+ssh:// andf git:// sometimes

set :use_sudo, true
set :scm_verbose, true
set :runner, nil

#############################################################
# Git
#############################################################

set :scm, :git
set :scm_user, "afterclassroom"
set :scm_passphrase, "huyettam"
set :repository, "git@github.com:afterclassroom/afterclassroom.git"
set :remote, "origin"
set :branch, "master"
set :deploy_via, :remote_cache
set :scm_verbose, true

#############################################################
# Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  task :after_update_code do
    db_config = <<-EOF
    login: &login 
      adapter: mysql2
      database: afterclassroom 
      username: after 
      password: 9Jke.w9itA
    # default configuration (slave) 
    production: 
      <<: *login
      host: localhost 
    #setup for masochism (master) 
    master_database: 
      <<: *login 
      host: 50.19.138.30
    staging:
      adapter: mysql2
      database: afterclassroom 
      username: after 
      password: after2011
    EOF

    put db_config, "#{release_path}/config/database.yml"
  end

  task :start, :roles => :app do
    # Bundle
    run "cd #{current_path} && bundle install"
    # Remove assets
    run "rm -rf public/assets/*.*"
    # Start Server
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
  # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
  # Start Server
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{current_path} && whenever --update-crontab #{application}"
  end
  
  after "deploy:symlink", "deploy:solr:symlink"
  after "deploy:symlink", "deploy:update_crontab"

  namespace :solr do
    desc <<-DESC
    Symlink in-progress deployment to a shared Solr index.
  DESC
    task :symlink, :except => { :no_release => true } do
      run "cd #{current_path} && rm -rf solr"
      run "ln -nfs #{shared_path}/solr #{current_path}/solr"
    end
  end
end
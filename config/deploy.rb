require "whenever/capistrano"

#############################################################
# Application
#############################################################
set :application, "Afterclassroom"
set :domain, "afterclassroom.com"
set :deploy_to, "/var/www/after"

#############################################################
# Settings
#############################################################
ssh_options[:paranoid] = true
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
default_run_options[:pty] = true # required for svn+ssh:// andf git:// sometimes

set :use_sudo, true
set :scm_verbose, true
set :rails_env, "production"
set :runner, nil

#############################################################
# Servers
#############################################################

set :user, "after"
set :domain, "afterclassroom.com"

server domain, :app, :web
role :db, domain, :primary => true

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

#############################################################
# Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  task :after_update_code do
    db_config = <<-EOF
    production:
      adapter: mysql2
      encoding: utf8
      username: after
      password: 9Jke.w9itA
      database: afterclassroom
    development:
      adapter: mysql2
      encoding: utf8
      username: after
      password: 9Jke.w9itA
      database: afterclassroom_development
    test:
      adapter: mysql2
      encoding: utf8
      username: after
      password: 9Jke.w9itA
      database: afterclassroom_test
    EOF

    put db_config, "#{release_path}/config/database.yml"
  end

  task :start, :roles => :app do
  # Bundle
    run "cd #{current_path} && bundle install"
    # Start Server
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :before_update_code do
  # Stop Solr
    run "cd #{current_path} && RAILS_ENV=#{rails_env} rake sunspot:solr:stop"
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
      run "cd #{current_path} && RAILS_ENV=#{rails_env} rake sunspot:solr:start"
    end
  end
end
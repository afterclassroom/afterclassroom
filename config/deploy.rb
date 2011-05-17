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
    run "cd #{release_path} && bundle install"
    # Stop Solr
    run "cd #{release_path} && RAILS_ENV=production rake sunspot:solr:stop"
    # Reindex
    run "cd #{release_path} && RAILS_ENV=production rake rake sunspot:reindex"
    # Start Solr
    run "cd #{release_path} && RAILS_ENV=production rake sunspot:solr:start"
    # Start Server
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  task :stop, :roles => :app do
    # Do nothing.
  end
  
  desc "Restart Application"
  task :restart, :roles => :app do
    # Start Server
    run "touch #{current_release}/tmp/restart.txt"
  end
end

namespace(:customs) do
  task :symlink, :roles => :app do
    run <<-CMD
      ln -nfs #{shared_path}/system/solr #{release_path}/solr
    CMD
  end
end

after "deploy:symlink","customs:symlink"
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

set :user, "root"
set :domain, "75.101.204.3"
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
      username: root
      password: 
      database: afterclassroom
      socket: /var/lib/mysql/mysql.sock
    EOF

    put db_config, "#{release_path}/config/database.yml"
    
    after "deploy:update_code", "deploy:pack_assets"

    task :start, :roles => :app do
      # Asset packager
      run "cd #{release_path} && rake asset:packager:delete_all"
      run "cd #{release_path} && rake asset:packager:build_all"
      # Stop Sphinx
      run "cd #{release_path} && rake ts:stop"
      # Start Sphinx
      run "cd #{release_path} && rake ts:start"
      # Stop Juggernault
      run "juggernaut -k -c #{current_release}/config/juggernaut.yml"
      # Start Juggernault
      run "juggernaut  -d -c #{current_release}/config/juggernaut.yml"
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
end
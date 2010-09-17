#############################################################
#	Application
#############################################################
require 'mongrel_cluster/recipes'


set :application, "Afterclassroom"
set :domain, "afterclassroom.com"
set :deploy_to, "/var/www/after"
set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml"

#############################################################
#	Settings
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
#	Servers
#############################################################

set :user, "root"
set :domain, "68.168.106.96:10222"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :scm_user, "afterclassroom"
set :scm_passphrase, "huyettam"
set :repository, "git@github.com:afterclassroom/afterclassroom.git"
set :remote, "origin"
set :branch, "master"
set :deploy_via, :remote_cache

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  task :after_update_code do
    db_config = <<-EOF
    production:
      adapter: mysql
      encoding: utf8
      username: after
      password: huyettam2010
      database: afterclassroom_production
      host: localhost
    
    development:
      adapter: mysql
      encoding: utf8
      username: after
      password: huyettam2010
      database: afterclassroom_production
      socket: /var/lib/mysql/mysql.sock
    EOF

    put db_config, "#{release_path}/config/database.yml"

    #########################################################
    # Uncomment the following to symlink an uploads directory.
    # Just change the paths to whatever you need.
    #########################################################

    # desc "Symlink the upload directories"
    # task :before_symlink do
    #   run "mkdir -p #{shared_path}/uploads"
    #   run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
    # end

  end

  namespace :deploy do
    task :start, :roles => :app do
      run "touch #{current_release}/tmp/restart.txt"
    end

    task :stop, :roles => :app do
      # Do nothing.
    end

    desc "Restart Application"
    task :restart, :roles => :app do
      run "touch #{current_release}/tmp/restart.txt"
    end
  end
end

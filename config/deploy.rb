#############################################################
#	Application
#############################################################
require 'mongrel_cluster/recipes'
#require 'vendor/plugins/thinking-sphinx/recipes/thinking_sphinx'

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
#  task :before_update_code, :roles => [:app] do
#    thinking_sphinx.stop
#  end

  desc "Create the database yaml file"
  task :after_update_code do
#    symlink_sphinx_indexes
#    thinking_sphinx.configure
#    thinking_sphinx.start
  
    db_config = <<-EOF
    production:
      adapter: mysql
      encoding: utf8
      username: after
      password: huyettam2010
      database: afterclassroom_production
      socket: /var/lib/mysql/mysql.sock
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

    desc "Symlink the upload directories"
    task :before_symlink do
      run "mkdir -p #{shared_path}/attaches"
      run "ln -s #{shared_path}/attaches #{release_path}/public/attaches"
      
      run "mkdir -p #{shared_path}/avatars"
      run "ln -s #{shared_path}/avatars #{release_path}/public/avatars"
      
      run "mkdir -p #{shared_path}/music_album_attaches"
      run "ln -s #{shared_path}/music_album_attaches #{release_path}/public/music_album_attaches"
      
      run "mkdir -p #{shared_path}/music_attaches"
      run "ln -s #{shared_path}/music_attaches #{release_path}/public/music_attaches"
      
      run "mkdir -p #{shared_path}/photo_attaches"
      run "ln -s #{shared_path}/photo_attaches #{release_path}/public/photo_attaches"
      
      run "mkdir -p #{shared_path}/photos"
      run "ln -s #{shared_path}/photos #{release_path}/public/photos"
    end
    
    desc "Pack assets with rucksack" 
    task :pack_assets, :roles => [:web,:app] do
      run "cd #{release_path} && rake RAILS_ENV=#{fetch(:rails_env, 'production')} rucksack:pack"
    end
    
    after "deploy:update_code", "deploy:pack_assets"

    task :start, :roles => :app do
      # Start Juggernault
      run "juggernaut -c #{current_release}/config/juggernaut.yml"
      # Start Server
      run "touch #{current_release}/tmp/restart.txt"
    end

    task :stop, :roles => :app do
      # Do nothing.
    end

    desc "Restart Application"
    task :restart, :roles => :app do
      # Start Juggernault
      run "juggernaut -c #{current_release}/config/juggernaut.yml"
      # Start Server
      run "touch #{current_release}/tmp/restart.txt"
    end
  end
  
  task :symlink_sphinx_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end
end
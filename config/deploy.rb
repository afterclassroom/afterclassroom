# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com
require "eycap/recipes"

set :keep_releases, 5
set :application,   'afterclassroom'
set :repository,    'git@github.com:afterclassroom/afterclassroom.git'
set :deploy_to,     "/data/#{application}"
set :deploy_via,    :export
set :monit_group,   "#{application}"
set :scm,           :git

# This is the same database name for all environments
set :production_database,'afterclassroom_production'

set :environment_host, 'localhost'
set :deploy_via, :remote_cache

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
default_run_options[:pty] = true # required for svn+ssh:// andf git:// sometimes

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision, 			lambda { source.query_revision(revision) { |cmd| capture(cmd) } }


task :afterclassroom do
  role :web, '174.129.195.49'
  role :app, '174.129.195.49'
  role :db, '174.129.195.49', :primary => true
  set :environment_database, Proc.new { production_database }
  set :dbuser,        'afterclassroom'
  set :dbpass,        'V7sCs4e1Ms'
  set :user,          'afterclassroom'
  set :password,      'V7sCs4e1Ms'
  set :runner,        'afterclassroom'
end


# TASKS
# Don't change unless you know what you are doing!
after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code","deploy:symlink_configs"
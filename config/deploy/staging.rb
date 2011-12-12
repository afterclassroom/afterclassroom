#############################################################
# Servers
#############################################################

set :user, "after"
set :domain, "dev.afterclassroom.com"

server domain, :app, :web
role :db, domain, :primary => true

set :deploy_to, "/var/www/after"
set :rails_env, "staging"

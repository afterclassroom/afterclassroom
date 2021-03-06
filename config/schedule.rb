# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
env :PATH, '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'
env :MAILTO, 'dungtqa@gmail.com'

set :output, "/var/log/cron_log.log"

every :reboot do
  rake "jobs:work"
  rake "sunspot:solr:start"
  #command "cd /var/www/juggernaut && nohup node server.js &"
end

# Delete share file expire
every 1.day, :at => '1:00 am' do 
  runner "Share.del_share_expire", :environment => :production
end

# Delete data user demo
every 1.day, :at => '1:00 am' do 
  runner "User.delete_data_user_demo", :environment => :production
end

# Backup database every 3 days
every 3.day, :at => '1:00 am' do 
  rake "db:backup"
end

# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
#ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

ENV['RECAPTCHA_PUBLIC_KEY']  = '6LcOAAwAAAAAAMFrzH8v6Fumgd001p8gxzc-XDfe'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LcOAAwAAAAAABX8iKvdQ3rkvxoOUp3nhDf4_Ufm'
  
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += %W( #{RAILS_ROOT}/app/middleware )
  # Gems
  config.gem "capistrano-ext", :lib => "capistrano"
  config.gem "configatron"
  config.gem(
    'thinking-sphinx',
    :lib     => 'thinking_sphinx',
    :version => '1.3.14'
  )
  config.gem "domainatrix"
  config.gem "hpricot"
  config.gem "rest-open-uri"
  
  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  config.time_zone = 'UTC'
  
  config.action_controller.session = {
    :session_key => '_swfupload_demo_session',
    :secret      => '1a72951ead92ea6e739efa07a4fcb2ca5a752f2e1143609d11a2d217eaa8cfa827d5f1c97af1470797db9fb417d0c6af0fe2b486f5c2760a5e258a8793c89294'
  }
  
  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store
  
  config.active_record.observers = :user_observer
end


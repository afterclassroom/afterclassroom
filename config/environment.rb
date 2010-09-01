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
  # Gems
  config.gem "capistrano-ext", :lib => "capistrano"
  config.gem "configatron"
  config.gem(
    'thinking-sphinx',
    :lib     => 'thinking_sphinx',
    :version => '1.3.14'
  )
  config.gem "domainatrix"
  config.gem "rest-open-uri"
  config.gem "hpricot"
  config.gem 'gdata', :lib => 'gdata'
  config.gem 'right_aws', :version => '2.0.0'
  
  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  config.time_zone = 'UTC'

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store
  
  config.active_record.observers = :user_observer
end

class CGI::Session
  alias original_initialize initialize
  def initialize(request, option = {})
    session_key = option['session_key'] || '_session_id'
    option['session_id'] =
      request.env_table["REQUEST_URI"][0..-1].
      scan(/#{session_key}=(.*?)(&.*?)*$/).
      flatten.first
    original_initialize(request, option)
  end
end

module ActiveResource
  # overrides the default ActiveResource Connection Class build_request_headers method because of this error:
  # http://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/1053-removed-http-header-accept-by-default
  class Connection
    def build_request_headers(headers, http_method=nil)
      authorization_header.update(default_header).update(headers)
    end
  end
end

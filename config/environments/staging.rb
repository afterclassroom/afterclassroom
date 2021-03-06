Afterclassroom::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb
  
  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = true
  
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  
  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"
  
  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  
  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files
  
  # See everything in the log (default is :info)
  # config.log_level = :debug
  
  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new
  
  # Use a different cache store in production
  config.cache_store = :dalli_store, '127.0.0.1:11211'
  
  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = true
  
  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"
  
  # Disable delivery errors, bad email addresses will be ignored
	config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :ses
  
  # Enable threaded mode
  # config.threadsafe!
  
  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true
  
  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
	
	# ExceptionNotifier
	config.after_initialize do
	config.middleware.use ExceptionNotifier,
		    :email_prefix => "[ERROR: Afterclassroom] ",																																																																															
		    :sender_address => '"Notifier" <support@afterclassroom.com>',
		    :exception_recipients => ['dungtqa@gmail.com']
	end
  
  # Restful Authentication
  REST_AUTH_SITE_KEY = '5a5e73a69a893311f859ccff1ffd0fa2d7ea25fd'
  REST_AUTH_DIGEST_STRETCHES = 15
  
  # Paperclip
  PAPERCLIP_STORAGE_OPTIONS = {}																																																																																																																																																																			
  Paperclip::Railtie.insert
  Paperclip.options[:command_path] = "/usr/bin/"

	# Omniauth
	ENV['FACEBOOK_KEY'] = "218775308176828"
	ENV['FACEBOOK_SECRET'] = "aae359b7c268836a7ecae7fb28d2e253"

	ENV['TWITTER_KEY'] = "ghvSN5NMgK7E5HduYox0Lg"
	ENV['TWITTER_SECRET'] = "woc6ZABfUprSUQujpHMEJiKkk1ztNX73ufeJZDz3lk"
end

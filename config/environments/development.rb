Afterclassroom::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
	config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :ses
	
	# Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
	
	# ExceptionNotifier
	config.after_initialize do
	config.middleware.use ExceptionNotifier,
		    :email_prefix => "[ERROR: Afterclassroom] ",
		    :sender_address => '"Notifier" <support@afterclassroom.com>',
		    :exception_recipients => ['dungtqa@gmail.com']
	end

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Restful Authentication
  REST_AUTH_SITE_KEY = '5a5e73a69a893311f859ccff1ffd0fa2d7ea25fd'
  REST_AUTH_DIGEST_STRETCHES = 15
  
  # Paperclip
  PAPERCLIP_STORAGE_OPTIONS = {}

	# Omniauth
	ENV['FACEBOOK_KEY'] = "181815955248907"
	ENV['FACEBOOK_SECRET'] = "2b729f219e09904eccbc9840d2c540fc"

	ENV['TWITTER_KEY'] = "8VFiOPrVrh6s3pDOPEZEjA"
	ENV['TWITTER_SECRET'] = "tLN93NsBLt5c7wpy6uL8yZIWgp3QcAUCWCsqD2tQ"
end

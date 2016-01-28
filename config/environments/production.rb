# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true  
config.action_mailer.default_charset = "utf-8" 
config.action_mailer.delivery_method = :smtp
#config.action_mailer.smtp_settings = {
#  :tls => true,
#  :address           => 'smtp.gmail.com', 
#  :port              => 587,
#  :domain            => 'gmail.com',
#  :authentication    => :plain,
#  :user_name         => 'kbrinley@gmail.com',
#  :password          => 'Travan4ever' 
#}
config.action_mailer.smtp_settings = {
  #:enable_starttls_auto               => false,
  :tls => true, 
  :address           => "mail.kanbanfordevelopers.com", 
  :port              => "587",
  :domain            => "kanbanfordevelopers.com",
  :authentication    => :plain,
  :user_name         => "no-reply@kanbanfordevelopers.com",
  :password          => "M7hJAkAJ" 
}
# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_transition_session',
    :secret      => '9008edaccf52e237d5051654f1dd7f5dfeae092779a55cd4123bb0d493b13581634fe19c32192a3a4e818e8babbd93860dd1ca748848c713b840871665faec45'
  }
    
  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
end

ActionController::UrlWriter.default_url_options[:host] = "maps.transitiontowns.org.nz"

GOOGLE_MAPS_KEYS = {
  "maps.transitiontowns.org.nz" => "ABQIAAAAeBPm_-KwgwjbZtYJENq_NxRcKxkoBfal55ZfotJlQLmBZmTm3xQunu9dMcsnu5dY-hQW9PXU3uvEQA",
  "localhost" => "ABQIAAAAeBPm_-KwgwjbZtYJENq_NxTJQa0g3IQ9GZqIMmInSLzwtGDKaBQEQ8RImFMMzng2wJSj--82s0XpKg",
  "map.swanson.org.nz" => "ABQIAAAAeBPm_-KwgwjbZtYJENq_NxSCoxnm7uBxUhAePM2hkpSLf111nBTZj4Q_FP04U4byjtwI-TDtPy6JVw"
}

require 'ostruct'
require 'yaml'

config = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/config.yml"))
env_config = config.send(RAILS_ENV)
config.common.update(env_config) unless env_config.nil?
::AppConfig = OpenStruct.new(config.common)
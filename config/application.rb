require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module RavenaBank
  class Application < Rails::Application
    config.load_defaults 6.0
    config.api_only = true
    config.time_zone = 'America/Sao_Paulo'
    config.active_record.default_timezone = :local

    # Send logs to STDOUT
    config.log_level = ENV['LOG_LEVEL']
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.log_tags  = %i[subdomain uuid]
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
end

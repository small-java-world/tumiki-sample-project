require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.require_master_key = false
  config.log_level = :info
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::Logger.new($stdout)
  config.logger.formatter = ::Logger::Formatter.new
  config.active_storage.service = :local
end



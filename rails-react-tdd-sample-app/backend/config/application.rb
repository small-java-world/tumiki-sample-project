require_relative 'boot'

# Ensure Ruby stdlib Logger is available before ActiveSupport references it
require 'logger'

require 'rails/all'

Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
  end
end



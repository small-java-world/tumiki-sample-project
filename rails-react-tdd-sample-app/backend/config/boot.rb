ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# Ensure stdlib Logger is available before ActiveSupport references it
require 'logger'

require 'bundler/setup'
begin
  require 'bootsnap/setup'
rescue LoadError
  # bootsnap is optional in this minimal setup
end



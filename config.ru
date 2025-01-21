# This file is used by Rack-based servers to start the application.

require "rack/canonical_host"
require_relative "config/environment"

# Redirect to primary host if in production
if Rails.env.production? && (CANONICAL_HOST = ENV["CANONICAL_HOST"] || ENV["HOST"])
  use Rack::CanonicalHost, CANONICAL_HOST
end

run Rails.application
Rails.application.load_server

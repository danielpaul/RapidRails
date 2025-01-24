if Rails.env.test?
  require "sidekiq/testing"
  Sidekiq::Testing.inline!
end

Sidekiq.configure_server do |config|
  config.redis = REDIS_CONFIG
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_CONFIG
end

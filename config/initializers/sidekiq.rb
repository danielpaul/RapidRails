if Rails.env.test?
  require "sidekiq/testing"
  Sidekiq::Testing.inline!
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV["REDIS_URL"] || ENV["REDISCLOUD_URL"],
    ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV["REDIS_URL"] || ENV["REDISCLOUD_URL"],
    ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}
  }
end

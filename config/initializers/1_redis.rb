REDIS_URL = ENV["REDIS_URL"] || ENV["REDISCLOUD_URL"] || "redis://localhost:6379/0"

REDIS_CONFIG = {
  url: REDIS_URL
}

REDIS_CONFIG[:ssl_params] = {verify_mode: OpenSSL::SSL::VERIFY_NONE} if Rails.env.production? || Rails.env.staging?

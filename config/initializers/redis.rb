REDIS_URL = ENV["REDIS_URL"] || ENV["REDISCLOUD_URL"] || "redis://localhost:6379/0"

REDIS_CONFIG = {
  url: REDIS_URL,
  ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}
}

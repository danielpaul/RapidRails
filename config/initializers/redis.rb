$redis = Redis.new(url: ENV["REDIS_URL"] || ENV["REDISCLOUD_URL"], ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE})

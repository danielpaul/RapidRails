class JwtTokenService
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.generate!(payload, expiration: 1.month.from_now)
    payload['exp'] = expiration.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode!(token)
    JWT.decode(token, SECRET_KEY)
  end

  def self.decode_without_validation!(token)
    JWT.decode(token, SECRET_KEY, true, { verify_expiration: false })
  end
end

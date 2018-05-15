class JsonWebToken
  ALGORITHM   = 'HS256'.freeze
  def self.encode(payload)
    main_payload = {
      iat: Time.zone.now.to_i,
      exp: Time.zone.now.to_i + 730.hours,
    }
    JWT.encode(payload.merge(main_payload), Rails.application.secrets.secret_key_base, ALGORITHM)
  end

  def self.decode(token)
    return HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: ALGORITHM)[0])
  rescue JWT::ExpiredSignature
    { error: 'Token expired' }
  rescue JWT::VerificationError
    { error: 'JWT verification error' }
  rescue JWT::DecodeError
    { error: 'Error encountered while decoding JWT token' }
  rescue
    { error: 'Invalid token' }
  end
end

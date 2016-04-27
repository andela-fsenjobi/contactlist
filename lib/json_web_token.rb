require "jwt"

class JsonWebToken
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.json_web_token_secret, "none")
  end

  def self.decode(token)
    JWT.decode(
      token,
      Rails.application.secrets.json_web_token_secret,
      false
    ).first
  end
end

require "json_web_token"

module Authenticable
  def current_user
    @current_user ||= get_user_from_token request.headers["Authorization"]
  end

  def authenticate_with_token
    render json: { errors: "Not authenticated" },
           status: 401 unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

  private

  def get_user_from_token(token)
    user = JsonWebToken.decode token
    User.find_by(email: user["email"], id: user["id"], is_logged_in: true)
  rescue
    nil
  end
end

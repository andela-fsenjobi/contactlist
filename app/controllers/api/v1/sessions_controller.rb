module Api
  module V1
    class SessionsController < ApplicationController
      before_action :authenticate_with_token, only: [:destroy]

      def create
        user_email = params[:email]
        user_password = params[:password]
        user = user_email.present? && User.find_by(email: user_email)

        if user.valid_password? user_password
          user.login
          payload = { email: user.email, id: user.id }
          token = JsonWebToken.encode payload
          data = {
            email: user.email,
            token: token,
            message: message.logged_in
          }
          render json: data, status: 200, location: [:api, user]
        else
          render json: { error: message.invalid_credentials }, status: 422
        end
      end

      def destroy
        current_user.logout
        render json: { message: message.logged_out }, status: 401
      end
    end
  end
end

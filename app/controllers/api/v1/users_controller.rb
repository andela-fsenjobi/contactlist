module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_with_token, only: [:create]

      def show
        render json: current_user
      end

      def create
        user = User.new(user_params)
        if user.save
          user.login
          payload = { email: user.email, id: user.id }
          token = JsonWebToken.encode payload
          data = {
            email: user.email,
            token: token,
            message: "User successfully created."
          }
          render json: data, status: 201
        else
          render json: { errors: user.errors }, status: 422
        end
      end

      def update
        user = current_user
        if user.update(user_params)
          render json: user, status: 201, location: [:api, user]
        else
          render json: { errors: user.errors }, status: 422
        end
      end

      def destroy
        current_user.destroy
        render json: { message: "User has been deleted" }, status: 204
      end

      private

      def user_params
        params.permit(:email, :password)
      end
    end
  end
end

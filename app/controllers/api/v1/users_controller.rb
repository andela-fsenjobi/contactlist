module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_with_token, only: [:update, :destroy]
      respond_to :json

      def show
        render json: current_user
      end

      def create
        user = User.new(user_params)
        if user.save
          data = {
            user: user,
            message: "User successfully created. Login to continue"
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
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end

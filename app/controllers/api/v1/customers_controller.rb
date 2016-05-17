module Api
  module V1
    class CustomersController < ApplicationController
      include DefaultActions
      before_action :authenticate_with_token
      before_action :set_customer, only: [:show, :update, :destroy]
      before_action :get_customers, only: [:index]

      def show
        render json: @customer
      end

      def create
        customer = current_user.customers.build(customer_params)
        save customer
      end

      def destroy
        @customer.destroy
        render json: { message: message.delete_message }, status: 200
      end

      private

      def set_customer
        @customer ||= Customer.find_by(
          id: params[:id],
          user_id: current_user.id
        )
      end

      def customer_params
        params.permit(:name, :phone, :referer, :user)
      end

      def get_customers
        if params[:q]
          @customers = current_user.customers.search(params[:q])
        else
          @customers = current_user.customers
        end
      end
    end
  end
end

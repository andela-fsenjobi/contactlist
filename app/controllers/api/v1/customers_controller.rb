module Api
  module V1
    class CustomersController < ApplicationController
      before_action :authenticate_with_token
      before_action :set_customer, only: [:show, :update, :destroy]
      before_action :get_customers, only: [:index]
      respond_to :json

      def show
        render json: @customer
      end

      def index
        page = params[:page].to_i > 0 ? params[:page].to_i : 1
        limit = params[:limit].to_i > 0 ? params[:limit].to_i : 20
        @customers.paginate(page, limit)
        render json: @customers, meta: {
          total: @customers.count,
          current: page
        }
      end

      def create
        customer = current_user.customers.build(customer_params)
        if customer.save
          render json: customer, status: 201, location: [:api, customer]
        else
          render json: { error: "Customer not created" }, status: 422
        end
      end

      def update
        if @customer.update(customer_params)
          render json: @customer, status: 201, location: [:api, @customer]
        else
          render json: { error: "Customer not created" }, status: 422
        end
      end

      def destroy
        if @customer.destroy
          render json: { message: "Record deleted" }, status: 204
        end
      end

      private

      def set_customer
        @customer ||= Customer.find_by(
          id: params[:id],
          user_id: current_user.id
        )
      end

      def customer_params
        params.require(:customer).permit(:name, :phone, :referer, :user)
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

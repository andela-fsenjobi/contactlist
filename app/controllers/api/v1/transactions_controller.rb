module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :set_transaction, only: [:show, :update, :destroy]
      before_action :authenticate_with_token
      respond_to :json

      def show
        render json: @transaction
      end

      def index
        @transactions = Transaction.all
        render json: @transactions
      end

      def create
        transaction = current_user.transactions.build(transaction_params)
        transaction.customer_id = params[:customer_id]
        if transaction.save
          render json: transaction, status: 201, location: [:api, transaction]
        else
          render json: { error: "Transaction not created" }, status: 422
        end
      end

      def update
        if @transaction.update(transaction_params)
          render json: @transaction, status: 201, location: [:api, @transaction]
        else
          render json: { error: "Transaction not created" }, status: 422
        end
      end

      def destroy
        if @transaction.destroy
          render json: { message: "Record deleted" }, status: 204
        end
      end

      private

      def set_transaction
        @transaction ||= Transaction.find(params[:id])
      end

      def transaction_params
        params.require(:transaction).permit(:amount, :status, :expiry, :user)
      end
    end
  end
end

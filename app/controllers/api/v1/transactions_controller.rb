module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :authenticate_with_token
      before_action :set_transaction, only: [:show, :update, :destroy]
      before_action :set_transactions, only: [:index]
      include DefaultActions

      def show
        render json: @transaction
      end

      def create
        transaction = current_user.transactions.build(transaction_params)
        transaction.customer_id = params[:customer_id]
        save transaction
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

      def set_transactions
        if params[:customer_id]
          return @transactions = Transaction.where(
            customer_id: params[:customer_id],
            user_id: current_user.id
          )
        else
          return @transactions = Transaction.where(user_id: current_user.id)
        end
      end

      def transaction_params
        params.permit(:amount, :status, :expiry, :user)
      end
    end
  end
end

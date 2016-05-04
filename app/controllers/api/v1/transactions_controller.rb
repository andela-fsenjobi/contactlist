module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :set_transaction, only: [:show, :update, :destroy]
      before_action :set_transactions, only: [:index]
      before_action :authenticate_with_token
      respond_to :json

      def show
        render json: @transaction
      end

      def index
        page = params[:page].to_i > 0 ? params[:page].to_i : 1
        limit = params[:limit].to_i > 0 ? params[:limit].to_i : 20
        total = @transactions.count
        @transactions = @transactions.paginate(page, limit)
        render json: @transactions, meta: {
          total: total,
          current: page
        }
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
        params.require(:transaction).permit(:amount, :status, :expiry, :user)
      end
    end
  end
end

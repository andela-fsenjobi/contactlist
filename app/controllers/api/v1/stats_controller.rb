module Api
  module V1
    class StatsController < ApplicationController
      before_action :authenticate_with_token

      def total
        render json: {
          total_customers: current_user.customers.count,
          total_transactions: current_user.transactions.count,
          total_gains: current_user.transactions.sum(:amount)
        }
      end

      def month
        customers = current_user.customers.by_month
        transactions = current_user.transactions.by_month
        render json: {
          month_customers: customers.count,
          month_transactions: transactions.count,
          month_gains: transactions.sum(:amount)
        }
      end

      def customers
        render json: current_user.customers.top.paginate
      end
    end
  end
end

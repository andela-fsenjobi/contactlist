module Api
  module V1
    class StatsController < ApplicationController
      before_action :authenticate_with_token
      respond_to :json

      def total
        respond_with data: {
          total_customers: current_user.customers.count,
          total_transactions: current_user.transactions.count,
          total_gains: current_user.transactions.sum(:amount)
        }
      end

      def month
        customers = current_user.customers.by_month
        transactions = current_user.transactions.by_month
        respond_with data: {
          month_customers: customers.count,
          month_transactions: transactions.count,
          month_gains: transactions.sum(:amount)
        }
      end

      def customers
        respond_with data: current_user.customers.top.paginate
      end
    end
  end
end

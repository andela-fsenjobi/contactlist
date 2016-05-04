class AddTransactionsCountToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :transactions_count, :integer, default: 0
  end
end

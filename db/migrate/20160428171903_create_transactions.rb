class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, index: true, foreign_key: true, null:false
      t.references :customer, index: true, foreign_key: true, null:false
      t.integer :amount, default: 0
      t.string :status
      t.date :expiry, null: false

      t.timestamps null: false
    end
  end
end

class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.integer :referer
      t.references :user, null: false

      t.timestamps null: false
    end
  end
end

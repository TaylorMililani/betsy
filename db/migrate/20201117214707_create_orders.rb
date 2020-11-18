class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :cc_num
      t.string :cc_expiration
      t.integer :cvv
      t.integer :billing_zip
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end

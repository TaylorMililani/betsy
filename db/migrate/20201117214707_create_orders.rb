class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.string :address
      t.integer :cc_num
      t.string :cc_expiration
      t.integer :ccv
      t.integer :billing_zip

      t.timestamps
    end
  end
end

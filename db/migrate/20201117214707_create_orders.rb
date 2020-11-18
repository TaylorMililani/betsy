class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :cc_num
      t.integer :ccv
      t.string :cc_expiration
      t.integer :billing_zip


      t.timestamps
    end
  end
end

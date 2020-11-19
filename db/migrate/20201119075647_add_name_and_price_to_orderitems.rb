class AddNameAndPriceToOrderitems < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :name, :string
    add_column :order_items, :price, :float
  end
end

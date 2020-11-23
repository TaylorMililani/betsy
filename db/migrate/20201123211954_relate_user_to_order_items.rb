class RelateUserToOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :order_items, :user, index: true
  end
end

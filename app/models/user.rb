class User < ApplicationRecord
    has_many :products
    has_many :orders
    # has_many :orderitems, through: :products
    has_many :order_items


    def self.build_from_github(auth_hash)
        user = User.new
        user.uid = auth_hash[:uid]
        user.provider = "github"
        user.username = auth_hash["info"]["name"]
        user.email = auth_hash["info"]["email"]

        return user
    end

    def total_revenue
        total = 0
        self.order_items.each do |item|
            total += item.subtotal
        end
        return total
    end

end

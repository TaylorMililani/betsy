class User < ApplicationRecord
    has_many :products
    has_many :orders


    def self.build_from_github(auth_hash)
        user = User.new
        user.uid = auth_hash[:uid]
        user.provider = "github"
        user.username = auth_hash["info"]["name"]
        user.email = auth_hash["info"]["email"]

        return user
    end

    def total_revenue(status = "all")
        total = 0
        self.order_items.find_each do |item|
            if status == "all"
                total += item.subtotal unless item.order.status == "cancelled"
            else
                total += item.subtotal if item.order.status == status
            end
        end
        return total
    end

end

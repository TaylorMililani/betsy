class User < ApplicationRecord
    has_many :products

    def self.build_from_github(auth_hash)
        user = User.new
        user.uid = auth_hash[:uid]
        user.provider = "github"
        user.username = auth_hash["info"]["name"]
        user.email = auth_hash["info"]["email"]

        return user
    end
end

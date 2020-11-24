class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :user
  has_many :reviews
  has_many :order_items

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }


  def self.products_in_stock
    products_in_stock = self.where.not(in_stock: 0)
    return products_in_stock
  end
end

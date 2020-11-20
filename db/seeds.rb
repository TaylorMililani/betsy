# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create([{name: "Science"}, {name: "Activism"}, {name: "Art"}, {name: "Superhero"}, {name: "Politics"}, {name: "Animal"}, {name: "Business"}, {name: "Celebrities"}, {name: "Happiness"}])

products = Product.create([{name: "Marie Curie", description: "Not great at chemistry? Get Marie Curie's brain for science!", price: 22000, in_stock: 10}, {name: "Ada Lovelace", description: "get some mad coding skills from none other than the mother of programming!", price: 28000, in_stock: 3}, {name: "Grace Hopper", description: "Get computer science skills and toughness from a pioneer of the field, Grace Hopper!", price: 30000, in_stock: 9}, {name: "Gloria Steinem", description: "Get the gumption of feminist hero, Gloria Steinem!", price: 23000, in_stock: 20}, {name: "Marsha P. Johnson", description: "Get the style, bravery, attitude, and all-around bad-assery of lgbtq+ rights activist, Marsha P. Johnson!", price: 50000, in_stock: 8}, {name: "Rosa Parks", description: "Get the strength, courage, and determination of legendary civil rights activist, Rosa Parks! Bonus item: her bus ticket!", price: 40000, in_stock: 10}])

users = User.create([{username: "STEMantics", email: "I_love_science@hotmath.com"}, {username: "eclectic_activism", email: "human_rights_r_cool@intersectionality.com"}])


Product.create([{name: "Frida Kahlo", description: "Artistic and creative artist", price: 500, in_stock: 10}, {name: "Salvador Dali", description: "Surrealistic painter", price: 1000, in_stock: 3}, {name: "Andy Warhol", description: "The Prince of Pop", price: 200, in_stock: 9}, {name: "Flash", description: "Superfast person", price: 120, in_stock: 20}, {name: "Superman", description: "Various superhuman abilities, such as incredible strength and impervious skin.", price: 500, in_stock: 3}, {name: "Wonder woman", description: "powerful, strong-willed character who does not back down from a fight or a challenge.", price: 3000, in_stock: 10}])


require 'csv'
puts "Added #{Category.count} Category records"
PRODUCTS_FILE = Rails.root.join('db', 'products_seeds.csv')
puts "Loading raw product data from #{PRODUCTS_FILE}"

product_failures = []
CSV.foreach(PRODUCTS_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.description = row['description']
  product.price = row['price']
  product.in_stock = row['in_stock']

  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"


CATEGORIES_PRODUCTS_FILE = Rails.root.join('db', 'category-product-seed.csv')
puts "Loading raw category data from #{CATEGORIES_PRODUCTS_FILE}"

categoryproduct_failures = []
CSV.foreach(CATEGORIES_PRODUCTS_FILE, :headers => true) do |row|
  category = Category.find_by(id: row["category_id"])
  product = Product.find_by(id: row["product_id"])
  product.categories << category

  successful = product.save

  if !successful
    categoryproduct_failures << product
    puts "Failed to add category #{category.inspect} to product #{product.inspect}"
  else
    puts "added category #{category.inspect} to product #{product.inspect}"
  end
end

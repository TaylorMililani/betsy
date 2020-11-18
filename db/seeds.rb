# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


products = Product.create([{name: "Marie Curie", description: "Not great at chemistry? Get Marie Curie's brain for science!", category: "Science", price: 22000, in_stock: 10}, {name: "Ada Lovelace", description: "get some mad coding skills from none other than the mother of programming!", category: "Science", price: 28000, in_stock: 3}, {name: "Grace Hopper", description: "Get computer science skills and toughness from a pioneer of the field, Grace Hopper!", category: "Science", price: 30000, in_stock: 9}, {name: "Gloria Steinem", description: "Get the gumption of feminist hero, Gloria Steinem!", category: "Activism", price: 23000, in_stock: 20}, {name: "Marsha P. Johnson", description: "Get the style, bravery, attitude, and all-around bad-assery of lgbtq+ rights activist, Marsha P. Johnson!", category: "Activism", price: 50000, in_stock: 8}, {name: "Rosa Parks", description: "Get the strength, courage, and determination of legendary civil rights activist, Rosa Parks! Bonus item: her bus ticket!", category: "Activism", price: 40000, in_stock: 10}])

merchants = Merchant.create([{username: "STEMantics", email: "I_love_science@hotmath.com"}, {username: "eclectic_activism", email: "human_rights_r_cool@intersectionality.com"}])

Product.create([{name: "Frida Kalo", description: "Artistic and creative artist", category: "Artist", price: 500, in_stock: 10}, {name: "Salvador Dali", description: "Surrealistic painter", category: "Artist", price: 1000, in_stock: 3}, {name: "Andy Warhol", description: "The Prince of Pop", category: "Artist", price: 200, in_stock: 9}, {name: "Flash", description: "Superfast person", category: "Superhero", price: 120, in_stock: 20}, {name: "Superman", description: "Various superhuman abilities, such as incredible strength and impervious skin.", category: "Superhero", price: 500, in_stock: 3}, {name: "Wonder woman", description: "powerful, strong-willed character who does not back down from a fight or a challenge.", category: "Superhero", price: 3000, in_stock: 10}])

require 'csv'

PRODUCTS_FILE = Rails.root.join('db', 'products_seeds.csv')
puts "Loading raw product data from #{PRODUCTS_FILE}"

product_failures = []
CSV.foreach(PRODUCTS_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.description = row['description']
  product.category = row['category']
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
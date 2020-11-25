# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create([{name: "Art"}, {name: "Superhero"}, {name: "Science"}, {name: "Activism"},  {name: "Politics"}, {name: "Animal"}, {name: "Business"}, {name: "Celebrities"}, {name: "Happiness"}])

users = User.create([{uid: 60956142, provider: "github", username: "nerdyistrendy", email: "li.lea.dai@gmail.com"}, {uid: 58778401, provider: "github", username: "TaylorMililani", email: "taylotmililani@gmail.com"}, {uid: 65133873, provider: "github", username: "indiakato", email: "india.kato@gmail.com"}, {uid: 26051021, provider: "github", username: "OlgaSe", email: "olga.tka4eva@gmail.com"}])

Product.create([{name: "Frida Kahlo", description: "Artistic and creative artist", price: 500, in_stock: 10, user_id: 1, photo: "https://assets.vogue.com/photos/5b280022dfb55f5d708a2985/master/w_1600%2Cc_limit/00-story-frida-kahlo-v-and-a.jpg"}, {name: "Salvador Dali", description: "Surrealistic painter", price: 1000, in_stock: 3, user_id: 2, photo: "https://uploads5.wikiart.org/images/salvador-dali.jpg!Portrait.jpg"}, {name: "Andy Warhol", description: "The Prince of Pop", price: 200, in_stock: 9, user_id: 3, photo: "https://upload.wikimedia.org/wikipedia/commons/4/42/Andy_Warhol_1975.jpg"}, {name: "Flash", description: "Superfast person", price: 120, in_stock: 20, user_id: 4, photo: "https://hips.hearstapps.com/digitalspyuk.cdnds.net/18/36/1536072683-the-flash-season-5-full-poster.jpeg?crop=1xw:0.8xh;center,top&resize=980:*"}, {name: "Superman", description: "Various superhuman abilities, such as incredible strength and impervious skin.", price: 500, in_stock: 3, user_id: 1, photo: "https://www.rollingstone.com/wp-content/uploads/2018/06/rs-27709-20130611-superman-x624-1370963561.jpg?resize=1800,1200&w=1200"}, {name: "Wonder woman", description: "powerful, strong-willed character who does not back down from a fight or a challenge.", price: 3000, in_stock: 10, user_id: 2, photo: "https://media.vanityfair.com/photos/5c4ddf0fba532c6650dedf67/master/w_2560%2Cc_limit/wonder-woman-3-modern.jpg"}])

products = Product.create([{name: "Marie Curie", description: "Not great at chemistry? Get Marie Curie's brain for science!", price: 22000, in_stock: 10, user_id: 3, photo: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Mariecurie.jpg/1280px-Mariecurie.jpg"}, {name: "Ada Lovelace", description: "get some mad coding skills from none other than the mother of programming!", price: 28000, in_stock: 3, user_id: 4, photo: "https://i1.wp.com/metro.co.uk/wp-content/uploads/2013/10/ay95895977ada-lovelace-engl1.jpg?quality=90&strip=all&zoom=1&resize=644%2C701&ssl=1"}, {name: "Grace Hopper", description: "Get computer science skills and toughness from a pioneer of the field, Grace Hopper!", price: 30000, in_stock: 9, user_id: 1, photo: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Commodore_Grace_M._Hopper%2C_USN_%28covered%29.jpg/1280px-Commodore_Grace_M._Hopper%2C_USN_%28covered%29.jpg"}, {name: "Gloria Steinem", description: "Get the gumption of feminist hero, Gloria Steinem!", price: 23000, in_stock: 20, user_id: 2, photo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Gloria_Steinem_%2829459760190%29_%28cropped%29.jpg/1280px-Gloria_Steinem_%2829459760190%29_%28cropped%29.jpg"}, {name: "Marsha P. Johnson", description: "Get the style, bravery, attitude, and all-around bad-assery of lgbtq+ rights activist, Marsha P. Johnson!", price: 50000, in_stock: 8, user_id: 3, photo: "https://upload.wikimedia.org/wikipedia/en/3/3c/A_photo_of_Marsha_P._Johnson.png"}, {name: "Rosa Parks", description: "Get the strength, courage, and determination of legendary civil rights activist, Rosa Parks! Bonus item: her bus ticket!", price: 40000, in_stock: 10, user_id: 4, photo: "https://upload.wikimedia.org/wikipedia/commons/c/c4/Rosaparks.jpg"}])


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
  product.photo = row['photo']
  product.user_id = 3

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

require "faker"
require 'date'
require "http"

Food.destroy_all
Tag.destroy_all
User.destroy_all

def random_collection_window
  start = Time.now + rand(0..3).days + rand(8..18).hours + rand(0..59).minutes
  finish = start + rand(1..3).hours
  [start, finish]
end


def random_dates_for_food
  cooking = Date.today - rand(0..2)
  expiry = cooking + rand(2..6)
  [cooking, expiry]
end

def random_quantity
  rand(1..5)
end

def random_expire_date(days = 3)
  Date.today + rand(1..days)
end

addresses = JSON.parse(File.read(Rails.root.join('db','london_addresses.json')))
addresses.shuffle!

users = [
  {
    email: "nasjwa@example.com",
    password: "123456",
    first_name: "Nasjwa",
    last_name: "Eddyani",
    address: "8 Camerton Cl, Hackney, London, E8 3TB, United Kingdom",
    post_code: "E8 3TB",
  },

  {
    email: "jean@example.com",
    password: "123456",
    first_name: "Jean",
    last_name: "Toneli",
    address: "179 Arlington Rd, Camden, London, NW1 7EY, United Kingdom",
    post_code: "NW1 7EY"
  },

  {
    email: "goncalo@example.com",
    password: "123456",
    first_name: "Gonçalo",
    last_name: "Freitas",
    address: "16 Gordon Pl, Kensington, London, W8 4JD, United Kingdom",
    post_code: "W8 4JD"
  },
].map { |attrs| User.create!(attrs) }

faker_users = 80.times.map do
  address = addresses.sample
  User.create!(
    first_name: Faker::Name.first_name,
    last_name:  Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    password: "123456",
    address: address["address"],
    post_code: address["post_code"],
  )
end

puts "Created #{users.count} users"
puts "Created #{faker_users.count} fake users."


tag_names = [
  "Vegan",
  "Vegetarian",
  "Gluten-Free",
  "Halal",
  "Kosher",
  "Dairy-Free",
  "Nuts-Free",
]

tags = tag_names.map { |name| Tag.create!(name: name) }.index_by(&:name)
puts "Created #{Tag.count} tags."

def create_food_with_tag(user, attrs, tags)
  start_time, end_time = random_collection_window
  cooking_date, expire_date = attrs[:kind_of_food] == 0 ? random_dates_for_food : [nil, Date.today + rand(10..30)]

  food = Food.create!(
    user: user,
    title: attrs[:title],
    description: attrs[:description],
    start_time: start_time,
    end_time: end_time,
    kind_of_food: attrs[:kind_of_food],
    cooking_date: cooking_date,
    expire_date: expire_date,
    quantity: rand(1..5)
  )

    (attrs[:tags] || []).each do |tag_name|
    tag = tags[tag_name]
    food.tags << tag if tag
  end
end


  meals = [
  { title: "Vegan Lentil Curry", tags: ["Vegan"], description: "A warming curry made with red lentils and coconut milk." },
  { title: "Tofu Stir Fry with Broccoli", tags: ["Vegan"], description: "Crispy tofu with broccoli, soy sauce, and sesame oil." },
  { title: "Sweet Potato Buddha Bowl", tags: ["Vegan"], description: "Roasted sweet potatoes, quinoa, chickpeas, and avocado." },
  { title: "Vegetarian Lasagna", tags: ["Vegetarian"], description: "Classic lasagna layered with ricotta, spinach, and tomato sauce." },
  { title: "Mushroom Risotto", tags: ["Vegetarian"], description: "Creamy risotto made with mushrooms and parmesan." },
  { title: "Caprese Salad", tags: ["Vegetarian", "Gluten-Free"], description: "Fresh tomatoes, mozzarella, and basil drizzled with olive oil." },
  { title: "Gluten-Free Chicken Fajitas", tags: ["Gluten-Free"], description: "Chicken fajitas served in gluten-free tortillas." },
  { title: "Grilled Salmon with Lemon", tags: ["Gluten-Free"], description: "Grilled salmon with lemon butter sauce." },
  # { title: "Beef Kebabs", tags: [], description: "Tender marinated beef skewers grilled to perfection." },
  # { title: "Chicken Biryani", tags: [], description: "Aromatic basmati rice cooked with spiced chicken and herbs." },
  { title: "Matzo Ball Soup", tags: ["Gluten-Free"], description: "Traditional soup with matzo balls and chicken broth." },
  # { title: "Roast Chicken", tags: [], description: "Golden-roasted chicken with vegetables and herbs." },
  { title: "Coconut Curry", tags: ["Vegan"], description: "Spicy coconut curry without dairy." },
  # { title: "Chicken Tikka Masala", tags: [], description: "Creamy Indian chicken curry with spices." },
  # { title: "Beef Stroganoff", tags: [], description: "Beef strips in creamy mushroom sauce over noodles." },
  # { title: "Spaghetti Carbonara", tags: [], description: "Pasta with pancetta, eggs, and parmesan cheese." },
  # { title: "Chicken Caesar Salad", tags: [], description: "Romaine lettuce with grilled chicken and Caesar dressing." },
  # { title: "Pulled Pork Sandwich", tags: [], description: "Slow-cooked pork with barbecue sauce in a soft bun." },
  { title: "Seafood Paella", tags: ["Gluten-Free"], description: "Spanish rice dish with shrimp, mussels, and saffron." },
  { title: "Tuna Nicoise Salad", tags: ["Gluten-Free"], description: "Salad with tuna, eggs, olives, and green beans." },
  { title: "Falafel Wrap", tags: ["Vegan"], description: "Middle Eastern wrap with crispy falafel and tahini sauce." },
  { title: "Vegetable Stir Fry", tags: ["Vegan"], description: "Colorful veggies sautéed in soy sauce and sesame oil." },
  { title: "Greek Salad", tags: ["Vegetarian", "Gluten-Free"], description: "Tomatoes, cucumber, olives, and feta cheese." },
  # { title: "Chicken Noodle Soup", tags: [], description: "Comforting soup with chicken, noodles, and carrots." },
  { title: "Vegetable Curry", tags: ["Vegan", "Gluten-Free"], description: "Curry made with seasonal vegetables and coconut milk." },
  { title: "Roast Vegetables with Hummus", tags: ["Vegan"], description: "Oven-roasted vegetables with homemade hummus." },
  { title: "Fish Tacos", tags: ["Gluten-Free"], description: "Grilled fish with salsa in gluten-free tortillas." },
  { title: "Shakshuka", tags: ["Vegetarian"], description: "Poached eggs in a spicy tomato sauce." },
  # { title: "Chicken Curry", tags: [], description: "Chicken curry with turmeric and coriander." },
  # { title: "Beef Chili", tags: [], description: "Slow-cooked chili con carne with beans and spices." },
  { title: "Pasta Primavera", tags: ["Vegetarian"], description: "Pasta with fresh vegetables in a light sauce." },
  # { title: "Fried Rice", tags: [], description: "Rice with mixed vegetables and soy sauce." },
  # { title: "Beef Burger", tags: [], description: "Burger with lettuce, tomato, and cheese." },
  { title: "Tomato Soup", tags: ["Vegan"], description: "Smooth tomato soup with herbs." },
  { title: "Couscous Salad", tags: ["Vegetarian"], description: "Light couscous salad with cucumber and mint." },
  { title: "Quinoa Bowl", tags: ["Vegan"], description: "Protein-packed quinoa bowl with veggies." },
  { title: "Spinach Omelette", tags: ["Vegetarian"], description: "Egg omelette with spinach and cheese." },
  { title: "Grilled Chicken Wrap", tags: ["Gluten-Free"], description: "Gluten-free wrap filled with grilled chicken and lettuce." },
  { title: "Beetroot Salad", tags: ["Vegetarian"], description: "Fresh beetroot with feta and arugula." },
  { title: "Rice and Beans", tags: ["Vegan", "Gluten-Free"], description: "Simple and filling meal of rice and beans." },
  { title: "Pumpkin Soup", tags: ["Vegan"], description: "Creamy pumpkin soup with coconut milk." },
  { title: "Vegetable Soup", tags: ["Vegan"], description: "Warm soup full of seasonal vegetables." },
  { title: "Fruit Salad", tags: ["Vegan", "Gluten-Free"], description: "Fresh fruits mixed for a healthy dessert." },
  { title: "Pea Soup", tags: ["Vegetarian"], description: "Thick pea soup with herbs and croutons." },
  { title: "Lentil Stew", tags: ["Vegan"], description: "Rich lentil stew with carrots and onions." },
  { title: "Eggplant Parmigiana", tags: ["Vegetarian"], description: "Baked eggplant layered with tomato sauce and cheese." },
  { title: "Stuffed Peppers", tags: ["Vegan"], description: "Bell peppers stuffed with rice and herbs." },
  { title: "Veggie Burger", tags: ["Vegan"], description: "Plant-based burger with lettuce and tomato." },
  { title: "Avocado Toast", tags: ["Vegan"], description: "Toasted bread topped with smashed avocado and seeds." },
  { title: "Garlic Bread", tags: ["Vegetarian"], description: "Crispy garlic bread with herbs and butter." }
]


meals.each do |meal|
  create_food_with_tag(faker_users.sample, meal.merge(kind_of_food: 0), tags)
end
puts "Created #{Food.where(kind_of_food: 0).count} cooked meals."

groceries = [
  { title: "Bag of Rice", description: "Unopened 1 kg bag of long-grain rice." },
  { title: "Canned Beans", description: "Two cans of kidney beans, ready to heat." },
  { title: "Pasta Pack", description: "500 g pack of penne pasta, sealed and dry." },
  { title: "Olive Oil Bottle", description: "Extra-virgin olive oil in a glass bottle." },
  { title: "Sugar Pack", description: "1 kg pack of white sugar for baking." },
  { title: "Flour Bag", description: "1 kg bag of wheat flour, unopened." },
  { title: "Salt Bag", description: "Full bag of table salt." },
  { title: "Tomato Sauce Jar", description: "Jar of tomato sauce for pasta." },
  { title: "Canned Tuna", description: "Three cans of tuna in water." },
  { title: "Peanut Butter Jar", description: "Unopened jar of smooth peanut butter." },
  { title: "Honey Bottle", description: "Bottle of natural honey, sealed." },
  # { title: "Oats Pack", description: "500 g pack of rolled oats." },
  # { title: "Chickpeas Can", description: "Two cans of chickpeas, ready to cook." },
  # { title: "Green Tea Box", description: "Box of 20 green tea bags." },
  # { title: "Coffee Beans", description: "250 g bag of medium roast coffee beans." },
  # { title: "Chocolate Bar", description: "Large dark chocolate bar, unopened." },
  # { title: "Cooking Oil", description: "1 L bottle of sunflower oil." },
  # { title: "Cereal Box", description: "Box of cornflakes, sealed and fresh." },
  # { title: "Canned Corn", description: "Can of sweet corn kernels." },
  # { title: "Dry Lentils", description: "500 g bag of red lentils." },
  # { title: "Bag of Potatoes", description: "5 kg of clean, fresh potatoes." },
  # { title: "Fresh Apples", description: "Six fresh apples for snacks." },
  # { title: "Bananas", description: "Bunch of ripe bananas." },
  # { title: "Milk Carton", description: "1 L carton of whole milk." },
  # { title: "Butter Pack", description: "250 g pack of unsalted butter." },
  # { title: "Yogurt Cup", description: "Four cups of plain yogurt." },
  # { title: "Cheese Block", description: "200 g block of cheddar cheese." },
  # { title: "Bottled Water", description: "Six 1 L bottles of mineral water." },
  # { title: "Canned Soup", description: "Can of tomato soup." },
  # { title: "Instant Noodles", description: "Five packs of instant noodles." }
]

groceries.each do |item|
  create_food_with_tag(faker_users.sample, item.merge(kind_of_food: 1, tags: ["Grocery"]), tags)
end
puts "Created #{Food.where(kind_of_food: 1).count} grocery items."

puts "Seeded #{Food.count} foods and #{Tag.count} tags."

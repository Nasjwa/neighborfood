require "faker"
require 'date'
require "http"
require "open-uri"


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

def resize_cloudinary(url)
  url.sub("/upload/", "/upload/w_800,h_600,c_fill,f_auto/")
end

def attach_cloudinary_photos(food, urls)
  urls.each do |url|
    transformed_url = resize_cloudinary(url)

    food.photos.attach(
      io: URI.open(transformed_url),
      filename: File.basename(URI.parse(url).path),
      content_type: "image/png"
    )
  end
end

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

  attach_cloudinary_photos(food, attrs[:photo_urls]) if attrs[:photo_urls]

  (attrs[:tags] || []).each do |tag_name|
    food.tags << tags[tag_name] if tags[tag_name]
  end

  food
end

meals = [
  { title: "Vegan Lentil Curry", tags: ["Vegan"], description: "A warming curry made with red lentils and coconut milk.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351214/Vegan_Lentil_Curry1_cy301y.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351222/Vegan_Lentil_Curry2_m9skth.png"] },
  { title: "Tofu Stir Fry with Broccoli", tags: ["Vegan"], description: "Crispy tofu with broccoli, soy sauce, and sesame oil.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351206/Tofu_Stir_Fry_with_Broccoli1_w0bemt.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351213/Tofu_Stir_Fry_with_Broccoli2_ukp4yo.png"] },
  { title: "Sweet Potato Buddha Bowl", tags: ["Vegan"], description: "Roasted sweet potatoes, quinoa, chickpeas, and avocado.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351206/Sweet_Potato_Buddha_Bowl1_izfneu.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351206/Sweet_Potato_Buddha_Bowl2_etpcdx.png"] },
  { title: "Vegetarian Lasagna", tags: ["Vegetarian"], description: "Classic lasagna layered with ricotta, spinach, and tomato sauce.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351231/Vegetarian_Lasagna1_o1dbqm.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351232/Vegetarian_Lasagna2_oeb0em.png"] },
  { title: "Mushroom Risotto", tags: ["Vegetarian"], description: "Creamy risotto made with mushrooms and parmesan.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351293/Mushroom_Risotto1_lt8hyb.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351171/Mushroom_Risotto2_ocgccv.png"] },
  { title: "Caprese Salad", tags: ["Vegetarian", "Gluten-Free"], description: "Fresh tomatoes, mozzarella, and basil drizzled with olive oil.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351245/Caprese_Salad1_vz0ajz.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351246/Caprese_Salad2_yqk8mi.png"] },
  { title: "Gluten-Free Chicken Fajitas", tags: ["Gluten-Free"], description: "Chicken fajitas served in gluten-free tortillas.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351270/Gluten-Free_Chicken_Fajitas2_hs36uc.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351268/Gluten-Free_Chicken_Fajitas1_wutjtv.png"] },
  { title: "Grilled Salmon with Lemon", tags: ["Gluten-Free"], description: "Grilled salmon with lemon butter sauce.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351282/Grilled_Salmon_with_Lemon1_t0toy5.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351282/Grilled_Salmon_with_Lemon2_kcwt6p.png"] },
  # { title: "Beef Kebabs", tags: [], description: "Tender marinated beef skewers grilled to perfection." },
  # { title: "Chicken Biryani", tags: [], description: "Aromatic basmati rice cooked with spiced chicken and herbs." },
  { title: "Matzo Ball Soup", tags: ["Gluten-Free"], description: "Traditional soup with matzo balls and chicken broth.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351282/Matzo_Ball_Soup1_nfzcld.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351293/Matzo_Ball_Soup2_xkrwdk.png"] },
  # { title: "Roast Chicken", tags: [], description: "Golden-roasted chicken with vegetables and herbs." },
  { title: "Coconut Curry", tags: ["Vegan"], description: "Spicy coconut curry without dairy.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351251/Coconut_Curry1_bjojlr.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351252/Coconut_Curry2_pdz0oe.png"] },
  # { title: "Chicken Tikka Masala", tags: [], description: "Creamy Indian chicken curry with spices." },
  # { title: "Beef Stroganoff", tags: [], description: "Beef strips in creamy mushroom sauce over noodles." },
  # { title: "Spaghetti Carbonara", tags: [], description: "Pasta with pancetta, eggs, and parmesan cheese." },
  # { title: "Chicken Caesar Salad", tags: [], description: "Romaine lettuce with grilled chicken and Caesar dressing." },
  # { title: "Pulled Pork Sandwich", tags: [], description: "Slow-cooked pork with barbecue sauce in a soft bun." },
  { title: "Seafood Paella", tags: ["Gluten-Free"], description: "Spanish rice dish with shrimp, mussels, and saffron.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351192/Seafood_Paella1_tcniof.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351192/Seafood_Paella2_m1j9nz.png"] },
  { title: "Tuna Nicoise Salad", tags: ["Gluten-Free"], description: "Salad with tuna, eggs, olives, and green beans.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351214/Tuna_Nicoise_Salad1_uklpao.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351214/Tuna_Nicoise_Salad2_jshorv.png"] },
  { title: "Falafel Wrap", tags: ["Vegan"], description: "Middle Eastern wrap with crispy falafel and tahini sauce.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351259/Falafel_Wrap1_oz3l3p.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351265/Falafel_Wrap2_jhi4ua.png"] },
  { title: "Vegetable Stir Fry", tags: ["Vegan"], description: "Colorful veggies sautéed in soy sauce and sesame oil.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351230/Vegetable_Stir_Fry1_u5h9yr.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351230/Vegetable_Stir_Fry2_qf3ze9.png"] },
  { title: "Greek Salad", tags: ["Vegetarian", "Gluten-Free"], description: "Tomatoes, cucumber, olives, and feta cheese.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351280/Greek_Salad1_ejaq7o.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351280/Greek_Salad2_u2djfb.png"] },
  # { title: "Chicken Noodle Soup", tags: [], description: "Comforting soup with chicken, noodles, and carrots." },
  { title: "Vegetable Curry", tags: ["Vegan", "Gluten-Free"], description: "Curry made with seasonal vegetables and coconut milk.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351223/Vegetable_Curry1_rfeiy4.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351223/Vegetable_Curry2_i332wy.png"] },
  { title: "Roast Vegetables with Hummus", tags: ["Vegan"], description: "Oven-roasted vegetables with homemade hummus.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351185/Roast_Vegetables_with_Hummus1_bbqxrj.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351191/Roast_Vegetables_with_Hummus2_swyw0b.png"] },
  { title: "Fish Tacos", tags: ["Gluten-Free"], description: "Grilled fish with salsa in gluten-free tortillas.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351263/Fish_Tacos1_usndde.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351267/Fish_Tacos2_gtlwar.png"] },
  { title: "Shakshuka", tags: ["Vegetarian"], description: "Poached eggs in a spicy tomato sauce.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351192/Shakshuka1_xfqutg.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351198/Shakshuka2_kdmdrw.png"] },
  # { title: "Chicken Curry", tags: [], description: "Chicken curry with turmeric and coriander." },
  # { title: "Beef Chili", tags: [], description: "Slow-cooked chili con carne with beans and spices." },
  { title: "Pasta Primavera", tags: ["Vegetarian"], description: "Pasta with fresh vegetables in a light sauce.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351171/Pasta_Primavera1_pnbgap.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351172/Pasta_Primavera2_fvkekt.png"] },
  # { title: "Fried Rice", tags: [], description: "Rice with mixed vegetables and soy sauce." },
  # { title: "Beef Burger", tags: [], description: "Burger with lettuce, tomato, and cheese." },
  { title: "Tomato Soup", tags: ["Vegan"], description: "Smooth tomato soup with herbs.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351213/Tomato_Soup1_rnfb5y.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351213/Tomato_Soup2_gjqxqj.png"] },
  { title: "Couscous Salad", tags: ["Vegetarian"], description: "Light couscous salad with cucumber and mint.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351252/Couscous_Salad1_hfchak.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351252/Couscous_Salad2_xyzrnd.png"] },
  { title: "Quinoa Bowl", tags: ["Vegan"], description: "Protein-packed quinoa bowl with veggies.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351182/Quinoa_Bowl1_pmx2im.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351182/Quinoa_Bowl2_euaexf.png"] },
  { title: "Spinach Omelette", tags: ["Vegetarian"], description: "Egg omelette with spinach and cheese.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351199/Spinach_Omelette1_lvtihr.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351199/Spinach_Omelette2_fzoar0.png"] },
  { title: "Grilled Chicken Wrap", tags: ["Gluten-Free"], description: "Gluten-free wrap filled with grilled chicken and lettuce.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351281/Grilled_Chicken_Wrap1_wuawwq.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351281/Grilled_Chicken_Wrap2_snioro.png"] },
  { title: "Beetroot Salad", tags: ["Vegetarian"], description: "Fresh beetroot with feta and arugula.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351245/Beetroot_Salad1_uqlavr.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351245/Beetroot_Salad2_jsnegk.png"] },
  { title: "Rice and Beans", tags: ["Vegan", "Gluten-Free"], description: "Simple and filling meal of rice and beans.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351182/Rice_and_Beans1_bloukp.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351183/Rice_and_Beans2_cefica.png"] },
  { title: "Pumpkin Soup", tags: ["Vegan"], description: "Creamy pumpkin soup with coconut milk.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351174/Pumpkin_Soup1_rjqqxe.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351181/Pumpkin_Soup2_cmcnap.png"] },
  { title: "Vegetable Soup", tags: ["Vegan"], description: "Warm soup full of seasonal vegetables.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351223/Vegetable_Soup1_uw1vbb.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351229/Vegetable_Soup2_zgn4p2.png"] },
  { title: "Fruit Salad", tags: ["Vegan", "Gluten-Free"], description: "Fresh fruits mixed for a healthy dessert.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351267/Fruit_Salad1_y9x3u3.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351267/Fruit_Salad2_q0n4b0.png"] },
  { title: "Pea Soup", tags: ["Vegetarian"], description: "Thick pea soup with herbs and croutons.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351172/Pea_Soup1_x71hgs.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351172/Pea_Soup2_jbpybo.png"] },
  { title: "Lentil Stew", tags: ["Vegan"], description: "Rich lentil stew with carrots and onions.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351281/Lentil_Stew1_bckm8z.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351282/Lentil_Stew2_u1rj91.png"] },
  { title: "Eggplant Parmigiana", tags: ["Vegetarian"], description: "Baked eggplant layered with tomato sauce and cheese.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351258/Eggplant_Parmigiana1_ym2ayl.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351258/Eggplant_Parmigiana2_cionsh.png"] },
  { title: "Stuffed Peppers", tags: ["Vegan"], description: "Bell peppers stuffed with rice and herbs.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351200/Stuffed_Peppers1_hyb9dv.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351205/Stuffed_Peppers2_dkxewr.png"] },
  { title: "Veggie Burger", tags: ["Vegan"], description: "Plant-based burger with lettuce and tomato.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351238/Veggie_Burger2_evaukz.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351238/Veggie_Burger1_jibxvc.png"] },
  { title: "Avocado Toast", tags: ["Vegan"], description: "Toasted bread topped with smashed avocado and seeds.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351239/Avocado_Toast1_rviyak.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351239/Avocado_Toast2_rq1yso.png"] },
  { title: "Garlic Bread", tags: ["Vegetarian"], description: "Crispy garlic bread with herbs and butter.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351267/Garlic_Bread1_xv7kjx.png", "https://res.cloudinary.com/daadrtkvx/image/upload/v1764351267/Garlic_Bread2_toydqp.png"] }
]


meals.each do |meal|
  create_food_with_tag(faker_users.sample, meal.merge(kind_of_food: 0), tags)
end
puts "Created #{Food.where(kind_of_food: 0).count} cooked meals."

groceries = [
  { title: "Bag of Rice", description: "Unopened 1 kg bag of long-grain rice.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351135/Bag_of_Rice_oiqv2j.png"] },
  { title: "Canned Beans", description: "Two cans of kidney beans, ready to heat.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351135/Canned_Beans_dtcv5v.png"] },
  { title: "Pasta Pack", description: "500 g pack of penne pasta, sealed and dry.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351136/Pasta_Pack_cz32uz.png"] },
  { title: "Olive Oil Bottle", description: "Extra-virgin olive oil in a glass bottle.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351137/Olive_Oil_Bottle_txvfpg.png"] },
  { title: "Sugar Pack", description: "1 kg pack of white sugar for baking.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351136/Sugar_Pack_k6cjgs.png"] },
  { title: "Flour Bag", description: "1 kg bag of wheat flour, unopened.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351136/Flour_Bag_cgmpyi.png"] },
  { title: "Salt Bag", description: "Full bag of table salt.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351136/Salt_Bag_ks62a1.png"] },
  { title: "Tomato Sauce Jar", description: "Jar of tomato sauce for pasta.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351137/Tomato_Sauce_Jar_wqj582.png"] },
  { title: "Canned Tuna", description: "Three cans of tuna in water.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351136/Canned_Tuna_lpawzj.png"] },
  { title: "Peanut Butter Jar", description: "Unopened jar of smooth peanut butter.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351135/Peanut_Butter_Jar_aqlncp.png"] },
  { title: "Honey Bottle", description: "Bottle of natural honey, sealed.", photo_urls: ["https://res.cloudinary.com/daadrtkvx/image/upload/v1764351136/Honey_Bottle_n6bsgo.png"] },
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

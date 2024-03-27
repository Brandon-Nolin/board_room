Game.delete_all
Category.delete_all
AdminUser.delete_all


ids = (1..10).to_a.join(',')
url = "https://boardgamegeek.com/xmlapi2/thing?id=#{ids}"

# Fetch the XML content from the URL
xml_data = URI.open(url).read

# Parse the XML data
doc = Nokogiri::XML(xml_data)

# Access elements using CSS selectors
# For example, to access all <item> elements:
items = doc.css('item')

counter = 0

# Iterate through each item
items.each do |item|
  counter += 1

  # Access the name elements with type="primary"
  name = item.at_css('name[type="primary"]')['value']
  description = item.at_css('description').text.strip
  min_age = item.at_css('minage')['value']
  min_players = item.at_css('minplayers')['value']
  max_players = item.at_css('maxplayers')['value']
  year_published = item.at_css('yearpublished')['value']
  price = Faker::Number.between(from: 20.0, to: 50.0).round(2)
  stock_quantity = Faker::Number.number(digits: 1)
  category_names = item.css('link[type="boardgamecategory"]').map { |link| link['value'] }
  sale_price = nil
  image = URI.open(item.at_css('image').text.strip)

  if counter % 5 == 0
    sale_price = Faker::Number.between(from: 10.0, to: price).round(2)
  end

  game = Game.create(
    name: name,
    description: description,
    min_age: min_age,
    min_players: min_players,
    max_players: max_players,
    year_published: year_published,
    current_price: price,
    stock_quantity: stock_quantity,
    sale_price: sale_price
  )

  category_names.each do |category_name|
    category = Category.find_or_create_by(name: category_name)
    game.categories << category
  end

  game.image.attach(io:image, filename: "#{name}.jpg")
  game.save

  sleep(1)
end

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
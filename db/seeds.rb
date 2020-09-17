15.times do |n|
  name = Faker::Movies::HarryPotter.character
  Topic.create!(name: name)
end

15.times do |n|
  name = Faker::Movies::HarryPotter.character
  Tag.create!(name: name)
end

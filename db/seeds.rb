# 15.times do |n|
#   name = Faker::Music.genre
#   Topic.create!(name: name)
# end

# 15.times do |n|
#   name = Faker::Movies::HarryPotter.character
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name: name,
#                email: email,
#                password: password,
#                password_confirmation: password,
#                activated: true,
#                activated_at: Time.zone.now,
#                status: "active",
#                role: "member")
# end

users = User.order(:created_at).take(3)

users.each do |user|
  10.times do
    title = Faker::Quotes::Shakespeare.romeo_and_juliet_quote
    content = Faker::Lorem.paragraphs[0]
    user.posts.create!(content: content,
                            topic_id: 7,
                            title: title)
  end
end

FactoryBot.define do
  factory :user do
    name {Faker::Movies::HarryPotter.character}
    email {Faker::Internet.email}
    password_digest {"123456"}
    activated_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    activated {true}
    status {Faker::Number.between from: 0, to: 1}
    created_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    updated_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    role {Faker::Number.between from: 0, to: 1}
    avatar {Rack::Test::UploadedFile.new(Rails.root.join("spec/support/fixture/default.jpg"))}
  end
end

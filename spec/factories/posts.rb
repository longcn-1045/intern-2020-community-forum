FactoryBot.define do
  factory :post do
    title {Faker::Book.title}
    content {Faker::Book.author}
    created_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    updated_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    status {Faker::Number.between from: 0, to: 2}
    user {FactoryBot.create :user}
    topic {FactoryBot.create :topic}
  end
end

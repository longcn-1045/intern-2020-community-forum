FactoryBot.define do
  factory :notification do
    created_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    updated_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    user {FactoryBot.create :user}
    post {FactoryBot.create :post}
  end
end

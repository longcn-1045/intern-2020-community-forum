FactoryBot.define do
  factory :relationship do
    follower {FactoryBot.create :user}
    followed {FactoryBot.create :user}
    created_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    updated_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
  end
end

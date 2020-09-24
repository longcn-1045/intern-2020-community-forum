FactoryBot.define do
  factory :topic do
    name {Faker::Name.name}
    created_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    updated_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    status {Faker::Number.between from: 0, to: 1}
  end
end

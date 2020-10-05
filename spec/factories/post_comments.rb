FactoryBot.define do
  factory :post_comment do
    user {FactoryBot.create :user}
    content {Faker::Book.author}
    created_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    updated_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    commentable {FactoryBot.create :post}
  end
end

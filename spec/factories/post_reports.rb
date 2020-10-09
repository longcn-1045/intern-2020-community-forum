FactoryBot.define do
  factory :post_report do
    user {FactoryBot.create :user}
    post {FactoryBot.create :post}
    report_reason {FactoryBot.create :report_reason}
    created_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    updated_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
  end
end

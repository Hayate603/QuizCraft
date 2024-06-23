FactoryBot.define do
  factory :quiz do
    title { "Sample Quiz" }
    description { "This is a sample description" }
    association :user
  end
end

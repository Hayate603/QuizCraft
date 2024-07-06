FactoryBot.define do
  factory :favorite_quiz do
    association :user
    association :quiz
  end
end

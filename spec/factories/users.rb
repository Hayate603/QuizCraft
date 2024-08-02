FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    confirmed_at { Time.zone.now }
    quiz_mode { User::QUIZ_MODES[:default] }

    trait :sns_user do
      provider { "google_oauth2" }
      uid { "123456" }
    end
  end
end

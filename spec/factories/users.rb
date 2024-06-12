FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "password" }
    confirmed_at { Time.zone.now }
  end
end

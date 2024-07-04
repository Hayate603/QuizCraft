FactoryBot.define do
  factory :quiz_session do
    association :user
    association :quiz
    start_time { Time.current }
    end_time { nil }

    trait :completed do
      end_time { Time.current }
    end
  end
end

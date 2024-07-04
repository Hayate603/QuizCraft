FactoryBot.define do
  factory :user_answer do
    association :user
    association :quiz
    association :question
    association :quiz_session
    answer_text { "MyString" }
    correct { false }

    trait :correct do
      answer_text { question.correct_answer }
      correct { true }
    end

    trait :incorrect do
      answer_text { "Wrong Answer" }
      correct { false }
    end
  end
end

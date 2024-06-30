FactoryBot.define do
  factory :user_answer do
    user { nil }
    quiz { nil }
    question { nil }
    quiz_session { nil }
    answer_text { "MyString" }
    correct { false }
  end
end

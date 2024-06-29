FactoryBot.define do
  factory :question do
    question_text { "Sample question" }
    correct_answer { "Sample answer" }

    after(:build) do |question|
      quiz = build(:quiz)
      question.quiz_questions << build(:quiz_question, quiz:, question:)
    end
  end
end

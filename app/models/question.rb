class Question < ApplicationRecord
  has_many :quiz_questions, dependent: :destroy
  has_many :quizzes, through: :quiz_questions
  has_many :user_answers, dependent: :destroy

  validates :question_text, presence: true
  validates :correct_answer, presence: true
  validate :must_be_associated_with_at_least_one_quiz

  before_destroy :ensure_no_quiz_associations

  def self.save_questions(questions_params, quiz)
    success_questions = []
    failed_questions = []

    questions_params.each do |question_param|
      question = build_question(question_param, quiz)
      save_question(question, success_questions, failed_questions)
    end

    [success_questions, failed_questions]
  end

  def self.parse_response(response)
    questions_and_answers = response["choices"][0]["message"]["content"].split("\n").reject(&:empty?)

    questions_and_answers.each_slice(2).filter_map do |question, answer|
      next if question.nil? || answer.nil?

      {
        question: question.sub("Q: ", ""),
        answer: answer.sub("A: ", "")
      }
    end
  end

  private

  class << self
    def build_question(question_param, quiz)
      question = Question.new(question_param)
      question.quizzes << quiz
      question
    end

    def save_question(question, success_questions, failed_questions)
      if question.save
        success_questions << { question_text: question.question_text, correct_answer: question.correct_answer }
      else
        failed_questions << { errors: question.errors.full_messages, question_text: question.question_text,
                              correct_answer: question.correct_answer }
      end
    end
  end

  def must_be_associated_with_at_least_one_quiz
    errors.add(:quizzes, "少なくとも1つのクイズに関連付けられている必要があります") if quizzes.empty?
  end

  def ensure_no_quiz_associations
    return unless quiz_questions.exists?

    errors.add(:base, "Cannot delete question with associated quizzes")
    throw(:abort)
  end
end

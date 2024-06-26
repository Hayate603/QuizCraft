class Question < ApplicationRecord
  has_many :quiz_questions, dependent: :destroy
  has_many :quizzes, through: :quiz_questions

  validates :question_text, presence: true
  validates :correct_answer, presence: true
  validate :must_be_associated_with_at_least_one_quiz

  before_destroy :ensure_no_quiz_associations

  private

  def must_be_associated_with_at_least_one_quiz
    errors.add(:quizzes, "少なくとも1つのクイズに関連付けられている必要があります") if quizzes.empty?
  end

  def ensure_no_quiz_associations
    if quiz_questions.exists?
      errors.add(:base, "Cannot delete question with associated quizzes")
      throw(:abort)
    end
  end
end



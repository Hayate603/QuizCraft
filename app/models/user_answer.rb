class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  belongs_to :question
  belongs_to :quiz_session

  before_save :check_correctness

  private

  def check_correctness
    self.correct = (answer_text == question.correct_answer)
  end
end

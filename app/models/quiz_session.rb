class QuizSession < ApplicationRecord
  belongs_to :user
  belongs_to :quiz

  validates :start_time, presence: true
end

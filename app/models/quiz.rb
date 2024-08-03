class Quiz < ApplicationRecord
  belongs_to :user
  has_many :quiz_questions, dependent: :destroy
  has_many :questions, through: :quiz_questions
  has_many :quiz_sessions, dependent: :destroy
  has_many :user_answers, dependent: :destroy
  has_many :favorite_quizzes, dependent: :destroy
  has_many :favorited_by, through: :favorite_quizzes, source: :user

  validates :title, presence: true, uniqueness: { scope: :user_id }
end

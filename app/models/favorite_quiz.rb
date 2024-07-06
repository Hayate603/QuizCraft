class FavoriteQuiz < ApplicationRecord
  belongs_to :user
  belongs_to :quiz

  validates :user_id, uniqueness: { scope: :quiz_id }
  validates :user, presence: true
  validates :quiz, presence: true
end

class Quiz < ApplicationRecord
  belongs_to :user
  has_many :quiz_questions, dependent: :destroy
  has_many :questions, through: :quiz_questions

  validates :title, presence: true, uniqueness: { scope: :user_id }
  validates :description, presence: true
end

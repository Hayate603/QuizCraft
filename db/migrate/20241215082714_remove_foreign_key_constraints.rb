class RemoveForeignKeyConstraints < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :quiz_sessions, :quizzes
    remove_foreign_key :quiz_sessions, :users
    remove_foreign_key :user_answers, :questions
    remove_foreign_key :user_answers, :quiz_sessions
  end
end

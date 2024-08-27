class RemoveUserIdAndQuizIdFromUserAnswers < ActiveRecord::Migration[7.1]
  def change
    remove_column :user_answers, :user_id, :bigint
    remove_column :user_answers, :quiz_id, :bigint
  end
end

class AddPublishToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :publish, :boolean, default: false, null: false
  end
end

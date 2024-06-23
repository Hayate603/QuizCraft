class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :question_text
      t.string :correct_answer

      t.timestamps
    end
  end
end

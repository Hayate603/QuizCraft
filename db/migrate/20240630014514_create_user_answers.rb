class CreateUserAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :user_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :quiz_session, null: false, foreign_key: true
      t.string :answer_text
      t.boolean :correct

      t.timestamps
    end
  end
end

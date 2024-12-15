class RemoveQuizSessionsAndUserAnswers < ActiveRecord::Migration[7.1]
  def change
    drop_table :quiz_sessions do |t|
      t.bigint :user_id, null: false
      t.bigint :quiz_id, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.timestamps
    end

    drop_table :user_answers do |t|
      t.bigint :question_id, null: false
      t.bigint :quiz_session_id, null: false
      t.string :answer_text
      t.boolean :correct
      t.timestamps
    end
  end
end

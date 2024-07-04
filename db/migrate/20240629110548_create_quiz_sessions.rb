class CreateQuizSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time

      t.timestamps
    end
  end
end

class AddDefaultToQuizModeInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :quiz_mode, 'default'
  end
end

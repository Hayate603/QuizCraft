class AddQuizModeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :quiz_mode, :string
  end
end

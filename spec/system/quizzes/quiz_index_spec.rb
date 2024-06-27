require 'rails_helper'

RSpec.describe 'Quiz Index', type: :system do
  let(:user) { create(:user) }
  let!(:quiz) { create(:quiz, user:, title: 'Sample Quiz', description: 'Sample description') }

  describe 'クイズ一覧の表示' do
    it 'クイズの一覧が表示されること' do
      visit quizzes_path
      expect(page).to have_content 'Sample Quiz'
      expect(page).to have_link 'Sample Quiz', href: quiz_path(quiz)
    end
  end
end

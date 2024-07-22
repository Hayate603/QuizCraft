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

  describe 'お気に入り機能' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'クイズをお気に入りに追加できること' do
        visit quizzes_path
        within(".quizzes__item--#{quiz.id}") do
          click_link 'お気に入りに追加'
        end
        expect(page).to have_content('クイズをお気に入りに追加しました。')
      end

      it 'クイズをお気に入りから削除できること' do
        user.favorite_quizzes.create!(quiz:)
        visit quizzes_path
        within(".quizzes__item--#{quiz.id}") do
          click_link 'お気に入りから削除'
        end
        expect(page).to have_content('クイズをお気に入りから削除しました。')
      end
    end

    context 'ログインしていない場合' do
      it 'お気に入りボタンが表示されないこと' do
        visit quizzes_path
        expect(page).not_to have_link('お気に入りに追加')
        expect(page).not_to have_link('お気に入りから削除')
      end
    end
  end
end

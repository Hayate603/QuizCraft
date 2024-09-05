require 'rails_helper'

RSpec.describe 'Quiz Index', type: :system do
  let(:user) { create(:user) }
  let!(:published_quiz) { create(:quiz, user:, title: '公開クイズ', publish: true) }
  let!(:unpublished_quiz) { create(:quiz, user:, title: '非公開クイズ', publish: false) }

  describe 'クイズ一覧の表示' do
    it '公開クイズが表示され、非公開クイズは表示されないこと' do
      visit quizzes_path
      expect(page).to have_content '公開クイズ'
      expect(page).not_to have_content '非公開クイズ'
    end
  end

  describe 'お気に入り機能' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'クイズをお気に入りに追加できること' do
        visit quizzes_path
        within(".quizzes__item--#{published_quiz.id}") do
          click_link 'お気に入りに追加'
        end
        expect(page).to have_content('クイズをお気に入りに追加しました。')
      end

      it 'クイズをお気に入りから削除できること' do
        user.favorite_quizzes.create!(quiz: published_quiz)
        visit quizzes_path
        within(".quizzes__item--#{published_quiz.id}") do
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

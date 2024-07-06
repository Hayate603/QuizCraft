require 'rails_helper'

RSpec.describe 'Favorite Quizzes', type: :system do
  let(:user) { create(:user) }
  let!(:quiz1) { create(:quiz, user:, title: 'Sample Quiz 1', description: 'Sample description 1') }
  let!(:quiz2) { create(:quiz, user:, title: 'Sample Quiz 2', description: 'Sample description 2') }

  before do
    user.favorite_quizzes.create!(quiz: quiz1)
  end

  describe 'お気に入りクイズ一覧ページの表示' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit user_favorite_quizzes_path(user)
      end

      it 'お気に入りに追加したクイズのリンクが表示されること' do
        expect(page).to have_link 'Sample Quiz 1', href: quiz_path(quiz1)
        expect(page).not_to have_content 'Sample Quiz 2'
      end

      it 'お気に入りから削除ボタンを押したらお気に入りから削除されること' do
        expect(page).to have_button 'お気に入りから削除'
        click_button 'お気に入りから削除'
        expect(page).to have_content 'クイズをお気に入りから削除しました。'
        expect(page).not_to have_content 'Sample Quiz 1'
      end
    end

    context 'ログインしていない場合' do
      it 'お気に入りクイズページにアクセスできないこと' do
        visit user_favorite_quizzes_path(user)
        expect(page).to have_content 'ログインしてください。'
      end
    end
  end
end

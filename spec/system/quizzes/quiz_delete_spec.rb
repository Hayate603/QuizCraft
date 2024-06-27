require 'rails_helper'

RSpec.describe 'Quiz Delete', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:quiz) { create(:quiz, user:, title: 'Sample Quiz', description: 'Sample description') }

  before do
    sign_in user
  end

  describe 'クイズの削除', js: true do
    context 'クイズを作成したユーザーの場合' do
      it 'クイズが削除されること' do
        visit quiz_path(quiz)
        expect(page).to have_content 'クイズを削除'
        accept_confirm do
          click_link 'クイズを削除'
        end

        expect(page).to have_content 'クイズが削除されました。'
        expect(page).not_to have_content 'Sample Quiz'
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it 'クイズの削除リンクが表示されないこと' do
        visit quiz_path(quiz)
        expect(page).not_to have_link 'クイズを削除'
      end
    end

    context 'クイズを作成したユーザーとは別のユーザの場合' do
      before do
        sign_out user
        sign_in another_user
      end

      it 'クイズの削除リンクが表示されないこと' do
        visit quiz_path(quiz)
        expect(page).not_to have_link 'クイズを削除'
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'Quiz Edit', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:quiz) { create(:quiz, user:, title: 'Sample Quiz', description: 'Sample description') }

  describe 'クイズ編集' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit edit_quiz_path(quiz)
      end

      context 'クイズ作成者の場合' do
        context '有効な情報が入力された場合' do
          it 'クイズが更新されること' do
            fill_in 'タイトル', with: 'Updated Quiz'
            fill_in '説明', with: 'This is an updated description'
            click_button 'クイズを更新'

            expect(page).to have_content 'クイズが更新されました。'
            expect(page).to have_content 'Updated Quiz'
            expect(page).to have_content 'This is an updated description'
          end
        end

        context '無効な値が入力された場合' do
          it 'タイトルが空である場合クイズを更新できないこと' do
            fill_in 'タイトル', with: ''
            click_button 'クイズを更新'

            expect(page).to have_content 'タイトルを入力してください'
          end

          it '説明が空である場合クイズを更新できないこと' do
            fill_in '説明', with: ''
            click_button 'クイズを更新'

            expect(page).to have_content '説明を入力してください'
          end
        end
      end

      context 'クイズ作成者とは別のユーザーの場合' do
        before do
          sign_out user
          sign_in another_user
        end

        it '編集ページにアクセスできないこと' do
          visit edit_quiz_path(quiz)
          expect(page).to have_content 'アクセス権がありません'
        end
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it '編集ページにアクセスできないこと' do
        visit edit_quiz_path(quiz)
        expect(page).to have_content 'ログインしてください'
      end
    end
  end
end

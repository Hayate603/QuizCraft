require 'rails_helper'

RSpec.describe 'Quiz Show', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:quiz) { create(:quiz, user:, title: 'Sample Quiz', description: 'Sample description') }
  let!(:question) do
    create(:question, question_text: 'Sample Question', correct_answer: 'Sample Answer', quizzes: [quiz])
  end

  describe 'クイズの詳細ページの表示' do
    it 'クイズの詳細が表示されること' do
      visit quiz_path(quiz)
      expect(page).to have_content 'Sample Quiz'
      expect(page).to have_content 'Sample description'
    end

    it 'クイズに関連する質問が表示されること' do
      visit quiz_path(quiz)
      expect(page).to have_content 'Sample Question'
    end

    it 'QRコードが表示されていること' do
      visit quiz_path(quiz)
      expect(page).to have_css('.qr-code svg')
    end

    context 'ログインしている場合' do
      context 'クイズ作成者としてログインしている場合' do
        before do
          sign_in user
          visit quiz_path(quiz)
        end

        it 'クイズの編集リンクが表示されること' do
          expect(page).to have_link 'クイズを編集', href: edit_quiz_path(quiz)
        end

        it 'クイズの削除リンクが表示されること' do
          expect(page).to have_link 'クイズを削除', href: quiz_path(quiz)
        end

        it 'クイズをお気に入りに追加できること' do
          click_button 'お気に入りに追加'
          expect(page).to have_content('クイズをお気に入りに追加しました。')
        end

        it 'クイズをお気に入りから削除できること' do
          user.favorite_quizzes.create!(quiz:)
          visit quiz_path(quiz)
          click_button 'お気に入りから削除'
          expect(page).to have_content('クイズをお気に入りから削除しました。')
        end
      end

      context 'クイズ作成者とは別のユーザーとしてログインしている場合' do
        before do
          sign_in another_user
          visit quiz_path(quiz)
        end

        it 'クイズの編集リンクが表示されないこと' do
          expect(page).not_to have_link 'クイズを編集'
        end

        it 'クイズの削除リンクが表示されないこと' do
          expect(page).not_to have_link 'クイズを削除'
        end

        it 'クイズをお気に入りに追加できること' do
          click_button 'お気に入りに追加'
          expect(page).to have_content('クイズをお気に入りに追加しました。')
        end

        it 'クイズをお気に入りから削除できること' do
          another_user.favorite_quizzes.create!(quiz:)
          visit quiz_path(quiz)
          click_button 'お気に入りから削除'
          expect(page).to have_content('クイズをお気に入りから削除しました。')
        end
      end
    end

    context '未ログインの場合' do
      before do
        visit quiz_path(quiz)
      end

      it 'クイズの編集リンクが表示されないこと' do
        expect(page).not_to have_link 'クイズを編集'
      end

      it 'クイズの削除リンクが表示されないこと' do
        expect(page).not_to have_link 'クイズを削除'
      end

      it 'お気に入りボタンが表示されないこと' do
        expect(page).not_to have_link('お気に入りに追加')
        expect(page).not_to have_link('お気に入りから削除')
      end
    end
  end
end

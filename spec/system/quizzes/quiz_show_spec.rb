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

    context 'ログイン状態による表示内容' do
      context 'クイズ作成者としてログインしている場合' do
        before do
          sign_in user
        end

        it 'クイズの編集リンクが表示されること' do
          visit quiz_path(quiz)
          expect(page).to have_link 'クイズを編集', href: edit_quiz_path(quiz)
        end

        it 'クイズの削除リンクが表示されること' do
          visit quiz_path(quiz)
          expect(page).to have_link 'クイズを削除', href: quiz_path(quiz)
        end
      end

      context '未ログインの場合' do
        it 'クイズの編集リンクが表示されないこと' do
          visit quiz_path(quiz)
          expect(page).not_to have_link 'クイズを編集'
        end

        it 'クイズの削除リンクが表示されないこと' do
          visit quiz_path(quiz)
          expect(page).not_to have_link 'クイズを削除'
        end
      end

      context 'クイズ作成者とは別のユーザーとしてログインしている場合' do
        before do
          sign_in another_user
        end

        it 'クイズの編集リンクが表示されないこと' do
          visit quiz_path(quiz)
          expect(page).not_to have_link 'クイズを編集'
        end

        it 'クイズの削除リンクが表示されないこと' do
          visit quiz_path(quiz)
          expect(page).not_to have_link 'クイズを削除'
        end
      end
    end
  end
end

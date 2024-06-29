require 'rails_helper'

RSpec.describe 'Question Management', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:quiz) { create(:quiz, user:) }
  let!(:question) { create(:question, question_text: 'これは削除のテスト質問です', correct_answer: '答え', quizzes: [quiz]) }

  describe '質問の削除' do
    context 'ログインしているユーザーの場合' do
      before do
        sign_in user
      end

      it '質問を削除できること', js: true do
        visit quiz_question_path(quiz, question)
        accept_confirm do
          click_link '質問を削除'
        end

        expect(page).to have_content('質問が削除されました。')
        expect(page).not_to have_content('これは削除のテスト質問です')
      end
    end

    context 'ログインしていないユーザーの場合' do
      before do
        sign_out user
      end

      it '質問の削除リンクが表示されないこと' do
        visit quiz_question_path(quiz, question)
        expect(page).not_to have_link('質問を削除')
        visit edit_quiz_question_path(quiz, question)
        expect(page).to have_content('ログインしてください。')
      end

      it '直接URLにアクセスして質問を削除できないこと' do
        page.driver.submit :delete, quiz_question_path(quiz, question), {}
        expect(page).to have_content('ログインしてください。')
      end
    end

    context '別のアカウントのユーザーの場合' do
      before do
        sign_out user
        sign_in other_user
      end

      it '質問の削除リンクが表示されないこと' do
        visit quiz_question_path(quiz, question)
        expect(page).not_to have_link('質問を削除')
      end

      it '直接URLにアクセスして質問を削除できないこと' do
        page.driver.submit :delete, quiz_question_path(quiz, question), {}
        expect(page).to have_content('アクセス権がありません')
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'Question Management', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:quiz) { create(:quiz, user: user) }
  let!(:question) { create(:question, question_text: 'これは編集前のテスト質問です', correct_answer: '答え', quizzes: [quiz]) }

  describe '質問の編集', js: true do
    context 'ログインしているユーザーの場合' do
      before do
        sign_in user
      end

      it '既存の質問を編集できること' do
        visit edit_quiz_question_path(quiz, question)
        fill_in '質問テキスト', with: 'これは編集後のテスト質問です'
        fill_in '正解', with: '更新された答え'
        click_button '質問を更新'

        expect(page).to have_content('質問が更新されました。')
        expect(page).to have_content('これは編集後のテスト質問です')
        expect(page).to have_content('更新された答え')
      end
    end

    context 'ログインしていないユーザーの場合' do
      before do
        sign_out user
      end

      it '質問の編集リンクが表示されないこと' do
        visit quiz_question_path(quiz, question)
        expect(page).not_to have_link('質問を編集')
        visit edit_quiz_question_path(quiz, question)
        expect(page).to have_content('ログインしてください。')
      end

      it '直接URLにアクセスして質問を編集できないこと' do
        visit edit_quiz_question_path(quiz, question)
        expect(page).to have_content('ログインしてください。')
      end
    end

    context '別のアカウントのユーザーの場合' do
      before do
        sign_in other_user
      end

      it '質問の編集リンクが表示されないこと' do
        visit quiz_question_path(quiz, question)
        expect(page).not_to have_link('質問を編集')
      end

      it '直接URLにアクセスして質問を編集できないこと' do
        visit edit_quiz_question_path(quiz, question)
        expect(page).to have_content('アクセス権がありません')
      end
    end
  end
end

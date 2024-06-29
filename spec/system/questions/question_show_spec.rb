require 'rails_helper'

RSpec.describe 'Question Show', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:quiz) { create(:quiz, user: user) }
  let!(:question) { create(:question, question_text: 'これは詳細表示のテスト質問です', correct_answer: '答え', quizzes: [quiz]) }

  describe '質問の詳細の表示' do
    context 'ログインしているユーザーの場合' do
      before do
        sign_in user
      end

      it '質問の詳細が表示され、編集と削除のリンクが表示されること' do
        visit quiz_question_path(quiz, question)

        expect(page).to have_content('これは詳細表示のテスト質問です')
        expect(page).to have_content('答え')
        expect(page).to have_link('質問を編集')
        expect(page).to have_link('質問を削除')
      end
    end

    context 'ログインしていないユーザーの場合' do
      before do
        sign_out user
      end

      it '質問の詳細が表示され、編集と削除のリンクが表示されないこと' do
        visit quiz_question_path(quiz, question)

        expect(page).to have_content('これは詳細表示のテスト質問です')
        expect(page).to have_content('答え')
        expect(page).not_to have_link('質問を編集')
        expect(page).not_to have_link('質問を削除')
      end
    end

    context '別のアカウントのユーザーの場合' do
      before do
        sign_in other_user
      end

      it '質問の詳細が表示され、編集と削除のリンクが表示されないこと' do
        visit quiz_question_path(quiz, question)

        expect(page).to have_content('これは詳細表示のテスト質問です')
        expect(page).to have_content('答え')
        expect(page).not_to have_link('質問を編集')
        expect(page).not_to have_link('質問を削除')
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'Question Creation', type: :system do
  let(:user) { create(:user) }
  let(:quiz) { create(:quiz, user: user) }

  before do
    sign_in user
  end

  describe '質問の作成' do
    context '有効な場合' do
      it '問題文と答えがあれば質問を作成できること' do
        visit new_quiz_question_path(quiz)
        fill_in '質問テキスト', with: 'これは新しい質問です'
        fill_in '正解', with: '答え'
        click_button '質問を作成'

        expect(page).to have_content('質問が作成されました。')
        expect(page).to have_content('これは新しい質問です')
      end
    end

    context '無効な場合' do
      it '問題文がなければ質問を作成できないこと' do
        visit new_quiz_question_path(quiz)
        fill_in '質問テキスト', with: ''
        fill_in '正解', with: '答え'
        click_button '質問を作成'

        expect(page).to have_content('質問テキストを入力してください')
      end

      it '答えがなければ質問を作成できないこと' do
        visit new_quiz_question_path(quiz)
        fill_in '質問テキスト', with: 'これは新しい質問です'
        fill_in '正解', with: ''
        click_button '質問を作成'

        expect(page).to have_content('正解を入力してください')
      end
    end

    context 'ログインしていないユーザーの場合' do
      before do
        sign_out user
      end

      it '質問作成ページにアクセスできず、ログインページにリダイレクトされること' do
        visit new_quiz_question_path(quiz)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('ログインしてください。')
      end
    end
  end
end

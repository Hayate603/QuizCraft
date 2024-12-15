require 'rails_helper'

RSpec.describe "クイズの実行", type: :system do
  let(:user) { create(:user) }
  let(:quiz) { create(:quiz, user:) }
  let!(:question1) { create(:question, question_text: '最初の質問', correct_answer: '答え1', quizzes: [quiz]) }
  let!(:question2) { create(:question, question_text: '二番目の質問', correct_answer: '答え2', quizzes: [quiz]) }
  let!(:question3) { create(:question, question_text: '三番目の質問', correct_answer: '答え3', quizzes: [quiz]) }

  before do
    sign_in user
  end

  context '新しいクイズセッションを開始する場合' do
    it 'クイズが開始され、最初の質問が表示されること' do
      visit start_quiz_path(quiz)
      expect(page).to have_content('最初の質問')
    end

    it '質問に回答し、次の質問が表示されること' do
      visit start_quiz_path(quiz, question_id: question1.id)
      fill_in 'あなたの回答', with: '答え1'
      click_button '回答を送信'
      expect(page).to have_content('二番目の質問')
    end
  end

  context 'クイズの結果' do
    it '全ての質問に回答した後、結果が表示されること' do
      visit start_quiz_path(quiz, question_id: question1.id)
      fill_in 'あなたの回答', with: '答え1'
      click_button '回答を送信'
      fill_in 'あなたの回答', with: '答え2'
      click_button '回答を送信'
      fill_in 'あなたの回答', with: '間違った答え3'
      click_button '回答を送信'
      expect(page).to have_content('クイズが完了しました！以下はあなたの結果です')
      expect(page).to have_content('質問')
      expect(page).to have_content('あなたの回答')
      expect(page).to have_content('正解')
      expect(page).to have_content('回答の正否')
      expect(page).to have_content('最初の質問')
      expect(page).to have_content('答え1')
      expect(page).to have_content('二番目の質問')
      expect(page).to have_content('答え2')
      expect(page).to have_content('三番目の質問')
      expect(page).to have_content('答え3')
      expect(page).to have_content('間違った答え3')
      expect(page).to have_content('総合結果')
      expect(page).to have_content('2 / 3')
    end
  end
end

require 'rails_helper'

RSpec.describe 'Quiz Creation', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe '新しいクイズの作成' do
    before do
      visit new_quiz_path
    end

    context '有効な情報が入力された場合' do
      it 'クイズが作成されること' do
        fill_in 'タイトル', with: 'Test Quiz'
        fill_in '説明', with: 'This is a test description'
        click_button 'クイズを作成'

        expect(page).to have_content 'クイズが作成されました。'
        expect(page).to have_content 'Test Quiz'
        expect(page).to have_content 'This is a test description'
      end

      it '他のユーザーなら同じタイトルのクイズでも作成できること' do
        Quiz.create!(title: 'Duplicate Title', description: 'This is a test description', user:)
        sign_out user
        sign_in another_user
        visit new_quiz_path
        fill_in 'タイトル', with: 'Duplicate Title'
        fill_in '説明', with: 'This is another test description'
        click_button 'クイズを作成'

        expect(page).to have_content 'クイズが作成されました。'
        expect(page).to have_content 'Duplicate Title'
        expect(page).to have_content 'This is another test description'
      end
    end

    context '無効な値が入力された場合' do
      it 'タイトルが空である場合クイズを作成できないこと' do
        fill_in 'タイトル', with: ''
        fill_in '説明', with: 'This is a test description'
        click_button 'クイズを作成'

        expect(page).to have_content 'タイトルを入力してください'
      end

      it '説明が空である場合クイズを作成できないこと' do
        visit new_quiz_path
        fill_in 'タイトル', with: 'Test Quiz'
        fill_in '説明', with: ''
        click_button 'クイズを作成'

        expect(page).to have_content '説明を入力してください'
      end

      it '同じユーザーが同じタイトルのクイズを作成できないこと' do
        Quiz.create!(title: 'Duplicate Title', description: 'This is a test description', user:)
        visit new_quiz_path
        fill_in 'タイトル', with: 'Duplicate Title'
        fill_in '説明', with: 'This is another test description'
        click_button 'クイズを作成'

        expect(page).to have_content 'Duplicate Titleというタイトルのクイズは既に存在します。別のタイトルを入力してください。'
      end
    end
  end

  describe 'クイズ一覧の表示' do
    let!(:quiz) { FactoryBot.create(:quiz, user:, title: 'Sample Quiz', description: 'Sample description') }

    it 'クイズの一覧が表示されること' do
      visit quizzes_path
      expect(page).to have_content 'Sample Quiz'
      expect(page).to have_link 'Sample Quiz', href: quiz_path(quiz)
    end
  end

  describe 'クイズの詳細の表示' do
    let!(:quiz) { FactoryBot.create(:quiz, user:, title: 'Sample Quiz', description: 'Sample description') }

    it 'クイズの詳細が表示されること' do
      visit quiz_path(quiz)
      expect(page).to have_content 'Sample Quiz'
      expect(page).to have_content 'Sample description'
    end
  end
end

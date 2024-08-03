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

      it '説明が空でもタイトルがあればクイズを作成できること' do
        visit new_quiz_path
        fill_in 'タイトル', with: 'Test Quiz'
        fill_in '説明', with: ''
        click_button 'クイズを作成'

        expect(page).to have_content 'クイズが作成されました。'
        expect(page).to have_content 'Test Quiz'
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
end

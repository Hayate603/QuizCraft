require 'rails_helper'

RSpec.describe 'My Quizzes', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:quiz1) { create(:quiz, user:, title: 'Sample Quiz 1', description: 'Sample description 1', publish: false) }
  let!(:quiz2) { create(:quiz, user:, title: 'Sample Quiz 2', description: 'Sample description 2', publish: true) }
  let!(:quiz3) { create(:quiz, title: 'Sample Quiz 3', description: 'Sample description 3', publish: true) }

  describe 'マイクイズページの表示' do
    context 'ログインユーザーの場合' do
      before do
        sign_in user
        visit user_my_quizzes_path(user)
      end

      it 'ログインユーザーのクイズのみが表示されること' do
        expect(page).to have_content 'Sample Quiz 1'
        expect(page).to have_content 'Sample Quiz 2'
        expect(page).not_to have_content 'Sample Quiz 3'
      end

      it 'クイズのリンクが表示されること' do
        expect(page).to have_link 'Sample Quiz 1', href: quiz_path(quiz1)
        expect(page).to have_link 'Sample Quiz 2', href: quiz_path(quiz2)
      end

      it '公開設定がオンに切り替わること', js: true do
        within("#publish-form-#{quiz1.id}") do
          find('.switch-slider').click
        end
        expect(page).to have_content 'クイズが公開されました。'
        visit root_path
        expect(page).to have_content 'Sample Quiz 1'
      end

      it '公開設定がオフに切り替わること', js: true do
        within("#publish-form-#{quiz2.id}") do
          find('.switch-slider').click
        end
        expect(page).to have_content 'クイズが非公開にされました。'
        visit root_path
        expect(page).not_to have_content 'Sample Quiz 2'
      end
    end

    context '別のユーザーの場合' do
      before do
        sign_in another_user
      end

      it '他のユーザーのクイズページにアクセスできないこと' do
        visit user_my_quizzes_path(user)
        expect(page).to have_content 'アクセス権がありません'
      end
    end

    context '未ログインユーザーの場合' do
      it 'ログインページにリダイレクトされること' do
        visit user_my_quizzes_path(user)
        expect(page).to have_content 'ログインしてください。'
      end
    end
  end
end

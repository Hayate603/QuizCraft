require 'rails_helper'

RSpec.describe "ログイン", type: :system do
  let(:user_email) { "user@example.com" }
  let(:user_password) { "password123" }
  let!(:user) { FactoryBot.create(:user, email: user_email, password: user_password) }

  context "有効な情報が入力された場合" do
    it "ユーザーがログインできること" do
      visit new_user_session_path
      fill_in "Email", with: user_email
      fill_in "Password", with: user_password
      click_button "Log in"
      expect(page).to have_content("ログインしました。")
    end
  end

  context "無効な情報が入力された場合" do
    it "ユーザーが無効なパスワードでログインできないこと" do
      visit new_user_session_path
      fill_in "Email", with: user_email
      fill_in "Password", with: "wrongpassword"
      click_button "Log in"
      expect(page).to have_content("メールアドレスまたはパスワードが違います。")
    end

    it "ユーザーが存在しないメールアドレスでログインできないこと" do
      visit new_user_session_path
      fill_in "Email", with: "nonexistent@example.com"
      fill_in "Password", with: "password123"
      click_button "Log in"
      expect(page).to have_content("メールアドレスまたはパスワードが違います。")
    end

    it "メールアドレスが空の場合にログインできないこと" do
      visit new_user_session_path
      fill_in "Email", with: ""
      fill_in "Password", with: user_password
      click_button "Log in"
      expect(page).to have_content("メールアドレスまたはパスワードが違います。")
    end

    it "パスワードが空の場合にログインできないこと" do
      visit new_user_session_path
      fill_in "Email", with: user_email
      fill_in "Password", with: ""
      click_button "Log in"
      expect(page).to have_content("メールアドレスまたはパスワードが違います。")
    end
  end
end

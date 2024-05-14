require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  context "有効な情報が入力された場合" do
    it "有効な情報が入力されたら登録が成功すること" do
      visit new_user_registration_path
      fill_in "Email", with: "valid@example.com"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"
      expect(page).to have_content("アカウント登録が完了しました。")
    end

    it "パスワードが6文字だと登録が成功すること" do
      visit new_user_registration_path
      fill_in "Email", with: "new@example.com"
      fill_in "Password", with: "passwd"
      fill_in "Password confirmation", with: "passwd"
      click_button "Sign up"
      expect(page).to have_content("アカウント登録が完了しました。")
    end
  end
  context "無効な情報が入力された場合" do
    it "メールアドレスが空であったら登録が失敗すること" do
      visit new_user_registration_path
      fill_in "Email", with: ""
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"
      expect(page).to have_content("Emailを入力してください")
    end

    it "メールアドレスが重複していたら登録が失敗すること" do
      visit new_user_registration_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"
      expect(page).to have_content("Emailはすでに存在します")
    end

    it "メールアドレスが無効なフォーマットであったら登録が失敗すること" do
      visit new_user_registration_path
      fill_in "Email", with: "invalid-email"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"
      expect(page).to have_content("Emailは不正な値です")
    end

    it "パスワードが5文字であったら登録が失敗すること" do
      visit new_user_registration_path
      fill_in "Email", with: "new@example.com"
      fill_in "Password", with: "passw"
      fill_in "Password confirmation", with: "passw"
      click_button "Sign up"
      expect(page).to have_content("Passwordは6文字以上で入力してください")
    end
    
    it "パスワードとパスワード確認が異なる場合無効であること" do
      visit new_user_registration_path
      fill_in "Email", with: "another@example.com"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "different123"
      click_button "Sign up"
      expect(page).to have_content("Password confirmationとPasswordの入力が一致しません")
    end
  end
end

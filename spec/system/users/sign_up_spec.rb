require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  context "有効な情報が入力された場合" do
    it "有効な情報が入力されたら登録が成功すること" do
      visit new_user_registration_path
      fill_in "メールアドレス", with: "valid@example.com"
      fill_in "パスワード", with: "password123"
      fill_in "パスワード確認", with: "password123"
      click_button "新規登録"
      expect(ActionMailer::Base.deliveries.count).to eq 1
      expect(page).to have_content("確認メールを送信しました。メール内のリンクをクリックしてアカウントを有効にしてください。")
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include("valid@example.com")
      expect(mail.body.encoded).to include('アカウント確認のために以下のリンクをクリックしてください。')
      confirmation_link = mail.body.encoded.match(/href="(?<url>.+?)">アカウント確認/)[:url]
      visit confirmation_link
      expect(page).to have_content('アカウントが確認されました。ログインしてください。')
    end

    it "パスワードが6文字だと登録が成功すること" do
      visit new_user_registration_path
      fill_in "メールアドレス", with: "valid@example.com"
      fill_in "パスワード", with: "passwd"
      fill_in "パスワード確認", with: "passwd"
      click_button "新規登録"
      expect(ActionMailer::Base.deliveries.count).to eq 1
      expect(page).to have_content("確認メールを送信しました。メール内のリンクをクリックしてアカウントを有効にしてください。")
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include("valid@example.com")
      expect(mail.body.encoded).to include('アカウント確認のために以下のリンクをクリックしてください。')
      confirmation_link = mail.body.encoded.match(/href="(?<url>.+?)">アカウント確認/)[:url]
      visit confirmation_link
      expect(page).to have_content('アカウントが確認されました。ログインしてください。')
    end
  end
  context "無効な情報が入力された場合" do
    it "メールアドレスが空であったら登録が失敗すること" do
      visit new_user_registration_path
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: "password123"
      fill_in "パスワード確認", with: "password123"
      click_button "新規登録"
      expect(page).to have_content("メールアドレスを入力してください")
    end

    it "メールアドレスが重複していたら登録が失敗すること" do
      visit new_user_registration_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password123"
      fill_in "パスワード確認", with: "password123"
      click_button "新規登録"
      expect(page).to have_content("メールアドレスはすでに存在します")
    end

    it "メールアドレスが無効なフォーマットであったら登録が失敗すること" do
      visit new_user_registration_path
      fill_in "メールアドレス", with: "invalid-email"
      fill_in "パスワード", with: "password123"
      fill_in "パスワード確認", with: "password123"
      click_button "新規登録"
      expect(page).to have_content("メールアドレスは不正な値です")
    end

    it "パスワードが5文字であったら登録が失敗すること" do
      visit new_user_registration_path
      fill_in "メールアドレス", with: "new@example.com"
      fill_in "パスワード", with: "passw"
      fill_in "パスワード確認", with: "passw"
      click_button "新規登録"
      expect(page).to have_content("パスワードは6文字以上で入力してください")
    end
    
    it "パスワードとパスワード確認が異なる場合無効であること" do
      visit new_user_registration_path
      fill_in "メールアドレス", with: "another@example.com"
      fill_in "パスワード", with: "password123"
      fill_in "パスワード確認", with: "different123"
      click_button "新規登録"
      expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")
    end
  end
end

require 'rails_helper'

RSpec.describe "アカウントロック機能", type: :system do
  let(:user) { FactoryBot.create(:user, email: "test@example.com", password: "password123") }

  before do
    ActionMailer::Base.deliveries.clear
    5.times do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "wrongpassword"
      click_button "ログイン"
    end
  end

  describe "アカウントロック" do
    it "ロックされたアカウントでログインしようとした場合にエラーメッセージが表示されること" do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
      expect(page).to have_content("アカウントがロックされています。")
    end

    it "ロック通知メールが送信されること" do
      expect(ActionMailer::Base.deliveries.count).to eq 1
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include(user.email)
      expect(mail.subject).to eq("アカウントロック解除のお知らせ")
    end
  end

  describe "アカウントアンロック" do
    it "アンロックメールが送信されること" do
      visit new_user_unlock_path
      fill_in "メールアドレス", with: user.email
      click_button "アンロック指示を送信"
      expect(ActionMailer::Base.deliveries.count).to eq 2 #ロックの通知とアンロックのメール
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include(user.email)
      expect(page).to have_content("アンロック指示を送信しました。")

      unlock_link = mail.body.encoded.match(/href="(?<url>.+?)">/)["url"]
      visit unlock_link

      expect(page).to have_content("アカウントのロックが解除されました。")
    end

    it "アンロック後にログインできること" do
      visit new_user_unlock_path
      fill_in "メールアドレス", with: user.email
      click_button "アンロック指示を送信"
      mail = ActionMailer::Base.deliveries.last
      unlock_link = mail.body.encoded.match(/href="(?<url>.+?)">/)["url"]
      visit unlock_link

      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
      expect(page).to have_content("ログインしました。")
    end
  end
end

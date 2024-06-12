require 'rails_helper'

RSpec.describe "パスワードリセット", type: :system do
  let(:user) { FactoryBot.create(:user, email: "user@example.com", password: "password") }

  it "パスワードリセットメールが送信されること" do
    ActionMailer::Base.deliveries.clear
    visit new_user_password_path
    fill_in "メールアドレス", with: user.email
    click_button "パスワードリセットの案内を送信"
    expect(ActionMailer::Base.deliveries.size).to eq(1)
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to include(user.email)
    expect(mail.subject).to include("Reset password instructions")
    expect(page).to have_content("パスワード再設定の手順を記載したメールを数分以内にお送りします。")
  end

  it "パスワードリセットが成功すること" do
    token = user.send_reset_password_instructions
    visit edit_user_password_path(reset_password_token: token)
    fill_in "新しいパスワード", with: "newpassword123"
    fill_in "新しいパスワード（確認用）", with: "newpassword123"
    click_button "パスワードを変更する"
    expect(page).to have_content("パスワードが正しく変更されました。")
  end

  it "存在しないメールアドレスが入力された場合、エラーメッセージが表示されること" do
    visit new_user_password_path
    fill_in "メールアドレス", with: "nonexistent@example.com"
    click_button "パスワードリセットの案内を送信"
    expect(page).to have_content("メールアドレスは見つかりません。")
  end
end

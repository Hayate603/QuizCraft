require 'rails_helper'

RSpec.describe "アカウント情報の更新", type: :system do
  let(:user) { FactoryBot.create(:user, email: "user@example.com", password: "password123") }

  before do
    sign_in user
  end

  it "ログイン中のユーザーがメールアドレスを変更できること" do
    visit edit_user_path(user)
    fill_in "メールアドレス", with: "newemail@example.com"
    fill_in "現在のパスワード", with: "password123"
    click_button "更新"

    expect(ActionMailer::Base.deliveries.count).to eq 1
    expect(page).to have_content("メールアドレスの変更には確認が必要です。確認メールを送信しました。")

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to include("newemail@example.com")
    expect(mail.body.encoded).to include('アカウント確認のために以下のリンクをクリックしてください。')

    confirmation_link = mail.body.encoded.match(/href="(?<url>.+?)">アカウント確認/)[:url]
    visit confirmation_link

    expect(page).to have_content('アカウントが確認されました。ログインしてください。')
    expect(user.reload.email).to eq("newemail@example.com")
  end

  it "ログイン中のユーザーがパスワードを変更できること" do
    visit edit_user_path(user)
    fill_in "現在のパスワード", with: "password123"
    fill_in "新しいパスワード", with: "newpassword123"
    fill_in "パスワード確認", with: "newpassword123"
    click_button "更新"
    expect(page).to have_content("アカウント情報が更新されました。")
  end

  it "現在のパスワードが間違っている場合、アカウント情報の更新が失敗すること" do
    visit edit_user_path(user)
    fill_in "メールアドレス", with: "newemail@example.com"
    fill_in "現在のパスワード", with: "wrongpassword"
    click_button "更新"
    expect(page).to have_content("現在のパスワードは不正な値です")
    expect(user.reload.email).to eq("user@example.com")
  end

  it "新しいパスワードと確認用パスワードが一致しない場合、パスワード変更が失敗すること" do
    visit edit_user_path(user)
    fill_in "現在のパスワード", with: "password123"
    fill_in "新しいパスワード", with: "newpassword123"
    fill_in "パスワード確認", with: "differentpassword123"
    click_button "更新"
    expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")
  end
end

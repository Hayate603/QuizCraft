require 'rails_helper'

RSpec.describe "アカウント削除", type: :system do
  let(:user) { FactoryBot.create(:user, email: "test@example.com", password: "password123") }
  let(:sns_user) { FactoryBot.create(:user, :sns_user, email: "sns_user@example.com", password: "password123") }
  let(:other_user) { FactoryBot.create(:user, email: "other@example.com", password: "password456") }

  it "アカウントを削除できること", js: true do
    sign_in user
    visit edit_user_path(user)
    accept_confirm do
      click_button "アカウントを削除する"
    end
    expect(page).to have_content("アカウントが削除されました。")
    expect(User.find_by(email: user.email)).to be_nil
  end

  it "削除確認ダイアログをキャンセルした場合、アカウントが削除されないこと", js: true do
    sign_in user
    visit edit_user_path(user)
    dismiss_confirm do
      click_button "アカウントを削除する"
    end
    expect(page).not_to have_content("アカウントが削除されました。")
    expect(User.find_by(email: user.email)).not_to be_nil
  end

  it "他のユーザーのアカウントが影響を受けないこと", js: true do
    sign_in user
    visit edit_user_path(user)
    accept_confirm do
      click_button "アカウントを削除する"
    end
    expect(User.find_by(email: other_user.email)).not_to be_nil
  end

  it "ログインしていないユーザーが削除ページにアクセスできないこと" do
    visit edit_user_path(user)
    expect(page).to have_content("ログインしてください。")
  end

  it "他のユーザーがアカウントの削除ページにアクセスできないこと" do
    sign_in other_user
    visit edit_user_path(user)
    expect(page).to have_content("アクセス権がありません。")
  end

  it "SNS認証ユーザーのアカウントを削除できること", js: true do
    sign_in sns_user
    visit edit_user_path(sns_user)
    accept_confirm do
      click_button "アカウントを削除する"
    end
    expect(page).to have_content("アカウントが削除されました。")
    expect(User.find_by(email: sns_user.email)).to be_nil
  end
end

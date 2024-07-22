require 'rails_helper'

RSpec.describe "ログアウト", type: :system do
  let(:user) { FactoryBot.create(:user, email: "user@example.com", password: "password") }

  before do
    sign_in user
    visit root_path
  end

  it "ヘッダーのログアウトリンクでユーザーがログアウトし、ホームページにリダイレクトされること" do
    within('.header') do
      click_link "ログアウト"
    end
    expect(page).to have_content("ログアウトしました。")
    expect(page).to have_current_path(root_path)
  end

  it "フッターのログアウトリンクでユーザーがログアウトし、ホームページにリダイレクトされること" do
    within('.footer') do
      click_link "ログアウト"
    end
    expect(page).to have_content("ログアウトしました。")
    expect(page).to have_current_path(root_path)
  end
end

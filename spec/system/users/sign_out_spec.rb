require 'rails_helper'

RSpec.describe "ログアウト", type: :system do
  let(:user) { FactoryBot.create(:user, email: "user@example.com", password: "password") }

  it "ユーザーがログアウトし、ホームページにリダイレクトされること" do
    sign_in user
    visit root_path
    click_link "ログアウト"
    expect(page).to have_content("ログアウトしました。")
    expect(page).to have_current_path(root_path)
  end
end

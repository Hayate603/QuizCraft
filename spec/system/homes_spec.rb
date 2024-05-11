require 'rails_helper'

RSpec.describe "Homes", type: :system do
  
  describe "認証関連リンクの表示" do
    context "ログインしていない場合" do
      it "ログインと新規登録のリンクが表示される" do
        visit root_path
        expect(page).to have_link('ログイン', href: new_user_session_path)
        expect(page).to have_link('新規登録', href: new_user_registration_path)
        expect(page).not_to have_link('ログアウト')
      end
    end

    context "ログインしている場合" do
      let(:user) { FactoryBot.create(:user) }

      it "ログアウトリンクとユーザーのメールアドレスが表示される" do
        login_as(user, scope: :user)
        visit root_path
        expect(page).to have_content("Welcome, #{user.email}")
        expect(page).to have_link('ログアウト', href: destroy_user_session_path)
        expect(page).not_to have_link('ログイン')
        expect(page).not_to have_link('新規登録')
      end
    end
  end
end

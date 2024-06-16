require 'rails_helper'

RSpec.describe "ログイン", type: :system do
  let(:user_email) { "user@example.com" }
  let(:user_password) { "password123" }
  let!(:user) { FactoryBot.create(:user, email: user_email, password: user_password) }
  let!(:user_google) { FactoryBot.create(:user, email: "test@example.com", provider: 'google_oauth2', uid: '000000') }
  let!(:user_facebook) do
    FactoryBot.create(:user, email: "facebook_test@example.com", provider: 'facebook', uid: '000001')
  end

  before do
    set_omniauth_mock_auth
  end

  describe "通常のログイン" do
    context "有効な情報が入力された場合" do
      it "ユーザーがログインできること" do
        visit new_user_session_path
        fill_in "メールアドレス", with: user_email
        fill_in "パスワード", with: user_password
        click_button "ログイン"
        expect(page).to have_content("ログインしました。")
      end
    end

    context "無効な情報が入力された場合" do
      it "ユーザーが無効なパスワードでログインできないこと" do
        visit new_user_session_path
        fill_in "メールアドレス", with: user_email
        fill_in "パスワード", with: "wrongpassword"
        click_button "ログイン"
        expect(page).to have_content("メールアドレスまたはパスワードが違います。")
      end

      it "ユーザーが存在しないメールアドレスでログインできないこと" do
        visit new_user_session_path
        fill_in "メールアドレス", with: "nonexistent@example.com"
        fill_in "パスワード", with: "password123"
        click_button "ログイン"
        expect(page).to have_content("メールアドレスまたはパスワードが違います。")
      end

      it "メールアドレスが空の場合にログインできないこと" do
        visit new_user_session_path
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: user_password
        click_button "ログイン"
        expect(page).to have_content("メールアドレスまたはパスワードが違います。")
      end

      it "パスワードが空の場合にログインできないこと" do
        visit new_user_session_path
        fill_in "メールアドレス", with: user_email
        fill_in "パスワード", with: ""
        click_button "ログイン"
        expect(page).to have_content("メールアドレスまたはパスワードが違います。")
      end
    end
  end

  describe "SNS認証によるログイン" do
    context "成功する場合" do
      it "Google OAuth2を使用してログインが成功すること" do
        visit new_user_session_path
        expect do
          click_button 'Googleでログイン'
          sleep 1
        end.to_not change(User, :count)
        expect(page).to have_content("Google アカウントによる認証に成功しました。")
      end

      it "Facebookを使用してログインが成功すること" do
        visit new_user_session_path
        expect do
          click_button 'Facebookでログイン'
          sleep 1
        end.to_not change(User, :count)
        expect(page).to have_content("Facebook アカウントによる認証に成功しました。")
      end
    end

    context "失敗する場合" do
      it "Google OAuth2で無効な資格情報の場合" do
        OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
        visit new_user_session_path
        expect do
          click_button 'Googleでログイン'
          sleep 1
        end.to_not change(User, :count)
        expect(page).to have_content("認証に失敗しました。")
      end

      it "Google OAuth2でプロバイダからのアクセスが拒否された場合" do
        OmniAuth.config.mock_auth[:google_oauth2] = :access_denied
        visit new_user_session_path
        expect do
          click_button 'Googleでログイン'
          sleep 1
        end.to_not change(User, :count)
        expect(page).to have_content("認証に失敗しました。")
      end

      it "Google OAuth2でタイムアウトが発生した場合" do
        allow(User).to receive(:from_omniauth).and_raise(Net::OpenTimeout)
        visit new_user_session_path
        expect do
          click_button 'Googleでログイン'
          sleep 1
        end.to_not change(User, :count)
        expect(page).to have_content("認証中にタイムアウトが発生しました。もう一度お試しください。")
      end
    end
  end
end

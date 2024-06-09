require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
    set_omniauth_mock_auth
  end

  describe "通常のユーザー登録" do
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

  describe "SNS認証" do
    context "成功する場合" do
      it "Google OAuth2を使用して登録が成功すること" do
        visit new_user_registration_path
        expect {
          click_button 'Googleで新規登録'
          sleep 1
        }.to change(User, :count).by(1)
      end
  
      it "Facebookを使用して登録が成功すること" do
        visit new_user_registration_path
        expect {
          click_button 'Facebookで新規登録'
          sleep 1
        }.to change(User, :count).by(1)
      end

      it "既存のユーザーがGoogle OAuth2を使って認証した場合、同一のユーザーとして認識されること" do
        existing_user = FactoryBot.create(:user, email: "existing@example.com")
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
          provider: 'google_oauth2',
          uid: '123545',
          info: { email: 'existing@example.com', name: 'Existing User' }
        })
        
        visit new_user_registration_path
        expect {
          click_button 'Googleで新規登録'
          sleep 1
        }.to_not change(User, :count)
        
        existing_user.reload
        expect(existing_user.provider).to eq 'google_oauth2'
        expect(existing_user.uid).to eq '123545'
      end
    end

    context "失敗する場合" do
      it "Google OAuth2で無効な資格情報の場合" do
        OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
        visit new_user_registration_path
        expect {
          click_button 'Googleで新規登録'
          sleep 1
        }.to_not change(User, :count)
        expect(page).to have_content("認証に失敗しました。")
      end

      it "Google OAuth2でプロバイダからのアクセスが拒否された場合" do
        OmniAuth.config.mock_auth[:google_oauth2] = :access_denied
        visit new_user_registration_path
        expect {
          click_button 'Googleで新規登録'
          sleep 1
        }.to_not change(User, :count)
        expect(page).to have_content("認証に失敗しました。")
      end

      it "Google OAuth2でメールアドレスが取得できなかった場合" do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
          provider: 'google_oauth2',
          uid: '123545',
          info: { email: nil }
        })
        visit new_user_registration_path
        expect {
          click_button 'Googleで新規登録'
          sleep 1
        }.to_not change(User, :count)
        expect(page).to have_content("認証に失敗しました。")
      end

      it "Google OAuth2でタイムアウトが発生した場合" do
        allow(User).to receive(:from_omniauth).and_raise(Net::OpenTimeout)
        visit new_user_registration_path
        expect {
          click_button 'Googleで新規登録'
          sleep 1
        }.to_not change(User, :count)
        expect(page).to have_content("認証中にタイムアウトが発生しました。もう一度お試しください。")
      end
    end
  end
end

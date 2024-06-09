class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth "Google"
  end

  def facebook
    handle_auth "Facebook"
  end

  def handle_auth(kind)
    begin
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: kind
        sign_in_and_redirect @user, event: :authentication
      else
        Rails.logger.debug "User could not be saved: #{@user.errors.full_messages}"
        Rails.logger.debug "OmniAuth data: #{request.env['omniauth.auth']}"
        session['devise.auth_data'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    rescue Net::OpenTimeout
      flash[:alert] = "認証中にタイムアウトが発生しました。もう一度お試しください。"
      redirect_to new_user_registration_url
    end
  end
end

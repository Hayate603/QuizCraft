module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      handle_auth "Google"
    end

    def facebook
      handle_auth "Facebook"
    end

    private

    def handle_auth(kind)
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        process_successful_auth(kind)
      else
        process_failed_auth
      end
    rescue Net::OpenTimeout
      handle_timeout
    end

    def process_successful_auth(kind)
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: kind)
      sign_in_and_redirect @user, event: :authentication
    end

    def process_failed_auth
      Rails.logger.debug { "User could not be saved: #{@user.errors.full_messages}" }
      Rails.logger.debug { "OmniAuth data: #{request.env['omniauth.auth']}" }
      session['devise.auth_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end

    def handle_timeout
      flash[:alert] = I18n.t('devise.omniauth_callbacks.timeout')
      redirect_to new_user_registration_url
    end
  end
end

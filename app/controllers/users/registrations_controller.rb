module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_user!, only: %i[edit update destroy]
    before_action :authorize_user, only: [:edit]
    before_action :restrict_guest_user, only: %i[edit update destroy]

    def update
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
      self.resource = find_resource
      if update_resource(resource, account_update_params)
        handle_successful_update(prev_unconfirmed_email)
      else
        handle_failed_update
      end
    end

    protected

    def update_resource(resource, params)
      if current_user.email == 'guest@example.com' && params.keys == ['quiz_mode']
        resource.update_without_password(params)
      else
        resource.provider.present? ? resource.update_without_password(params) : resource.update_with_password(params)
      end
    end

    def after_update_path_for(resource)
      stored_location_for(resource) || request.referer || root_path
    end

    private

    def account_update_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :quiz_mode)
    end

    def authorize_user
      user = User.find_by(id: params[:id])
      redirect_to(root_path, alert: I18n.t('devise.failure.unauthorized_access')) if user.nil? || (current_user != user)
    end

    def find_resource
      resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    end

    def handle_successful_update(prev_unconfirmed_email)
      flash[:notice] = if resource.respond_to?(:unconfirmed_email) &&
                          resource.unconfirmed_email != prev_unconfirmed_email
                         I18n.t('devise.registrations.update_needs_confirmation')
                       else
                         I18n.t('devise.registrations.updated')
                       end
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      redirect_to after_update_path_for(resource)
    end

    def handle_failed_update
      clean_up_passwords resource
      set_minimum_password_length
      render :edit
    end

    def restrict_guest_user
      return unless current_user.email == 'guest@example.com'
      return if params[:user] && account_update_params.keys == ["quiz_mode"]

      redirect_to root_path, alert: I18n.t('devise.failure.guest_restricted')
    end
  end
end

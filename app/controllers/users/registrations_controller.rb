module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_user!, only: %i[edit update destroy]
    before_action :authorize_user, only: [:edit]

    protected

    def update_resource(resource, params)
      if resource.provider.present?
        resource.update_without_password(params)
      else
        resource.update_with_password(params)
      end
    end

    private

    def authorize_user
      user = User.find_by(id: params[:id])
      redirect_to(root_path, alert: I18n.t('devise.failure.unauthorized_access')) if user.nil? || (current_user != user)
    end
  end
end

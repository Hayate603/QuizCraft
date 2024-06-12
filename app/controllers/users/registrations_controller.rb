module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_user!, only: %i[edit update destroy]
    before_action :authorize_user, only: [:edit]

    private

    def authorize_user
      user = User.find_by(id: params[:id])
      return redirect_to(root_path, alert: "アクセス権がありません。") if user.nil? || (current_user != user)
    end
  end
end

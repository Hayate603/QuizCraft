class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :authorize_user, only: [:edit]

  private

  def authorize_user
    user = User.find_by(id: params[:id])
    if (user == nil) || (current_user != user)
      redirect_to root_path, alert: "アクセス権がありません。"
    end
  end
end

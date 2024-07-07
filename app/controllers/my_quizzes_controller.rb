class MyQuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def index
    @quizzes = current_user.quizzes
  end

  private

  def correct_user
    user = User.find(params[:user_id])
    return if current_user == user

    redirect_to(root_path, alert: I18n.t('alerts.access_denied'))
  end
end

class FavoriteQuizzesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorite_quizzes = current_user.favorite_quizzes.includes(:quiz).page(params[:page]).per(10)
  end

  def create
    quiz = Quiz.find(params[:quiz_id])
    current_user.favorite_quizzes.create!(quiz:)
    redirect_back fallback_location: quiz, notice: I18n.t('notices.favorite_quiz_added')
  end

  def destroy
    quiz = Quiz.find(params[:quiz_id])
    current_user.favorite_quizzes.find_by(quiz:).destroy
    redirect_back fallback_location: quiz, notice: I18n.t('notices.favorite_quiz_removed')
  end
end

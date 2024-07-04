class QuizSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz

  def update
    @quiz_session = QuizSession.find(params[:id])
    if @quiz_session.update(end_time: Time.current)
      redirect_to quiz_results_path(@quiz_session.quiz), notice: I18n.t('notices.quiz_session_ended')
    else
      redirect_to @quiz_session, alert: I18n.t('alerts.end_quiz_session_failed')
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end

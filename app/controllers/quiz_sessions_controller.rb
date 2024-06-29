class QuizSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz

  def create
    @quiz_session = @quiz.quiz_sessions.build(user: current_user, start_time: Time.current)
    if @quiz_session.save
      redirect_to @quiz_session, notice: "Quiz session started!"
    else
      redirect_to @quiz, alert: "Failed to start quiz session."
    end
  end

  def update
    @quiz_session = QuizSession.find(params[:id])
    if @quiz_session.update(end_time: Time.current)
      redirect_to quiz_results_path(@quiz_session.quiz), notice: "Quiz session ended!"
    else
      redirect_to @quiz_session, alert: "Failed to end quiz session."
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end

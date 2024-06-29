class QuizzesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_quiz, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @quizzes = Quiz.all
  end

  def show; end

  def new
    @quiz = Quiz.new
  end

  def edit; end

  def create
    @quiz = current_user.quizzes.build(quiz_params)
    if @quiz.save
      redirect_to @quiz, notice: I18n.t('notices.quiz_created')
    else
      render :new
    end
  end

  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: I18n.t('notices.quiz_updated')
    else
      render :edit
    end
  end

  def destroy
    @quiz.destroy
    redirect_to quizzes_url, notice: I18n.t('notices.quiz_deleted')
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def authorize_user!
    return if @quiz.user == current_user

    redirect_to quizzes_path, alert: I18n.t('alerts.access_denied')
  end

  def quiz_params
    params.require(:quiz).permit(:title, :description)
  end
end

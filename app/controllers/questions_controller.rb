class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_quiz, only: %i[new create]
  before_action :authorize_user!, only: %i[edit update destroy]

  def new
    @question = @quiz.questions.build
  end

  def create
    @question = Question.new(question_params)
    @question.quizzes << @quiz
    if @question.save
      redirect_to quiz_path(@quiz), notice: I18n.t('notices.question_created')
    else
      render :new
    end
  end

  def show
    @quiz = @question.quizzes.first
  end

  def edit
    @quiz = @question.quizzes.first
  end

  def update
    if @question.update(question_params)
      redirect_to quiz_question_path(@question.quizzes.first, @question), notice: I18n.t('notices.question_updated')
    else
      render :edit
    end
  end

  def destroy
    quiz = @question.quizzes.first
    @question.destroy
    redirect_to quiz_path(quiz), notice: I18n.t('notices.question_deleted')
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def question_params
    params.require(:question).permit(:question_text, :correct_answer)
  end

  def authorize_user!
    unless @question.quizzes.first.user == current_user
      redirect_to root_path, alert: I18n.t('alerts.access_denied')
    end
  end
end

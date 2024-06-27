class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_quiz, only: %i[new create]

  def new
    @question = @quiz.questions.build
  end

  def create
    @question = @quiz.questions.build(question_params)
    if @question.save
      redirect_to [@quiz, @question], notice: I18n.t('notices.question_created')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: I18n.t('notices.question_updated')
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_url, notice: I18n.t('notices.question_deleted')
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
end

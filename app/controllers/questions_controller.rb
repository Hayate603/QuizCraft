class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: I18n.t('notices.question_created')
    else
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  private

  def question_params
    params.require(:question).permit(:question_text, :correct_answer)
  end
end

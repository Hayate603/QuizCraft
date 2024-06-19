class QuizzesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @quizzes = Quiz.all
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = current_user.quizzes.build(quiz_params)
    if @quiz.save
      redirect_to @quiz, notice: 'クイズが作成されました。'
    else
      render :new
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(:title, :description)
  end
end

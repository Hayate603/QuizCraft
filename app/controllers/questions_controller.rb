class QuestionsController < ApplicationController
  include QuestionsHelper
  before_action :authenticate_user!, only: %i[new create edit update destroy save_all_questions]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_quiz, only: %i[new create edit update generate_from_image save_all_questions]
  before_action :authorize_user!, only: %i[edit update destroy]

  def show
    @quiz = @question.quizzes.first
  end

  def new
    @question = @quiz.questions.build
  end

  def edit
    @quiz = @question.quizzes.first
  end

  def create
    @question = Question.new(question_params)
    @question.quizzes << @quiz
    if @question.save
      render json: { success: true, message: I18n.t('notices.question_created') }, status: :created
    else
      render json: { success: false, errors: @question.errors.full_messages }, status: :ok
    end
  end

  def save_all_questions
    questions_params = fetch_questions_params
    success_questions, failed_questions = Question.save_questions(questions_params, @quiz)

    if failed_questions.empty?
      render json: { success: true, message: I18n.t('notices.all_questions_created') }
    else
      render json: { success: false, errors: failed_questions, success_questions: }
    end
  end

  def generate_from_image
    service = QuestionGeneratorService.new(params[:image])
    extracted_text = service.generate_from_image
    render json: { text: extracted_text, message: I18n.t('notices.text_extracted_from_image') }
  end

  def generate_questions_from_text
    service = QuestionGeneratorService.new(nil, params[:extracted_text])
    response = service.generate_from_text
    questions_and_answers = Question.parse_response(response)
    render json: { questions: questions_and_answers, message: I18n.t('notices.questions_generated') }
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

  def fetch_questions_params
    questions_data = JSON.parse(params[:questions_data])['questions']
    questions_data.map do |q|
      ActionController::Parameters.new(q).permit(:question_text, :correct_answer)
    end
  end

  def authorize_user!
    return if @question.quizzes.first.user == current_user

    redirect_to root_path, alert: I18n.t('alerts.access_denied')
  end
end

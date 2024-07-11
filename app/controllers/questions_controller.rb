class QuestionsController < ApplicationController
  include QuestionsHelper
  before_action :authenticate_user!, only: %i[new create edit update destroy save_all_questions]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_quiz, only: %i[new create generate_from_image save_all_questions]
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
      render json: { success: true }, status: :created
    else
      render json: { success: false, error: @question.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def save_all_questions
    questions_params = fetch_questions_params
    no_errors, errors = save_questions(questions_params, @quiz)

    if no_errors
      render json: { success: true }
    else
      render json: { success: false, errors: }
    end
  end

  def generate_from_image
    uploaded_image = params[:image].tempfile
    vision = Google::Cloud::Vision.image_annotator
    response = vision.text_detection(image: uploaded_image)
    extracted_text = response.responses.first.text_annotations.first.description

    render json: { text: extracted_text }
  end

  def generate_questions_from_text
    extracted_text = params[:extracted_text]
    client = OpenAI::Client.new
    response = fetch_openai_response(client, extracted_text)

    questions_and_answers = parse_response(response)

    render json: { questions: questions_and_answers }
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
    return if @question.quizzes.first.user == current_user

    redirect_to root_path, alert: I18n.t('alerts.access_denied')
  end
end

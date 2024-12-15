class QuizzesController < ApplicationController
  include QuizHelpers

  before_action :authenticate_user!,
                only: %i[new create edit update toggle_publish destroy take results start answer_question]
  before_action :set_quiz, only: %i[show edit update toggle_publish destroy take results start answer_question]
  before_action :authorize_user!, only: %i[edit update toggle_publish destroy]

  def index
    @quizzes = Quiz.published.page(params[:page]).per(10)
  end

  def show
    @qr = RQRCode::QRCode.new(quiz_url(@quiz))
    @questions = @quiz.questions.page(params[:page]).per(10)
  end

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

  def toggle_publish
    if @quiz.user == current_user
      @quiz.update(publish: !@quiz.publish)
      respond_to do |format|
        format.json { render_quiz_publish_status }
      end
    else
      respond_to do |format|
        format.json { render_access_denied }
      end
    end
  end

  def destroy
    @quiz.destroy
    redirect_to quizzes_url, notice: I18n.t('notices.quiz_deleted')
  end

  def start
    session[:quiz_progress] = {
      "quiz_id" => @quiz.id,
      "start_time" => Time.current.iso8601,
      "answers" => []
    }
    redirect_to take_quiz_path(@quiz)
  end

  def take
    redirect_if_no_questions(@quiz) && return

    quiz_progress = session[:quiz_progress]
    redirect_unless_valid_session(quiz_progress, @quiz) && return

    @question = assign_next_question(quiz_progress, @quiz)
    redirect_to results_quiz_path(@quiz) if @question.nil?
  end

  def answer_question
    quiz_progress = session[:quiz_progress]
    return redirect_to_invalid_session(@quiz) unless valid_session?(quiz_progress, @quiz)

    process_answer(quiz_progress, params[:question_id], params[:answer_text], @quiz)
    redirect_to take_quiz_path(@quiz), notice: I18n.t('notices.answer_submitted')
  end

  def results
    quiz_progress = session[:quiz_progress]
    return redirect_to_no_completed_session(@quiz) unless valid_results_session?(quiz_progress, @quiz)

    prepare_results(quiz_progress, @quiz)
    clear_quiz_session
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
    params.require(:quiz).permit(:title, :description, :publish)
  end

  def render_quiz_publish_status
    render json: {
      publish: @quiz.publish,
      message: quiz_publish_message
    }, status: :ok
  end

  def render_access_denied
    render json: { error: I18n.t('alerts.access_denied') }, status: :forbidden
  end

  def quiz_publish_message
    @quiz.publish ? I18n.t('notices.quiz_published') : I18n.t('notices.quiz_unpublished')
  end
end

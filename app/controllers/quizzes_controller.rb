class QuizzesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy take results start resume]
  before_action :set_quiz, only: %i[show edit update destroy take results start resume]
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

  def take
    @existing_session = find_existing_session
    if resume_session?
      @resume_session = true
    else
      start_new_session
    end
  end

  def results
    @quiz_session = find_last_completed_session
    if @quiz_session&.end_time
      @user_answers = @quiz_session.user_answers
    else
      redirect_to quizzes_path, alert: I18n.t('alerts.no_completed_session')
    end
  end

  def start
    end_existing_session
    @quiz_session = QuizSession.create(user: current_user, quiz: @quiz, start_time: Time.current)
    redirect_to take_quiz_path(@quiz, question_id: @quiz.questions.first.id, resume_session: "false")
  end

  def resume
    existing_session = find_existing_session
    last_answered_question_id = existing_session&.user_answers&.last&.question_id
    next_question = find_next_question(last_answered_question_id)
    redirect_to take_quiz_path(@quiz, question_id: next_question.id, resume_session: "false")
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

  def find_existing_session
    QuizSession.find_by(user: current_user, quiz: @quiz, end_time: nil)
  end

  def resume_session?
    @existing_session && params[:resume_session] != "false"
  end

  def start_new_session
    @existing_session ||= QuizSession.create(user: current_user, quiz: @quiz, start_time: Time.current)
    @question = params[:question_id] ? @quiz.questions.find(params[:question_id]) : @quiz.questions.first
    @user_answer = UserAnswer.new
  end

  def find_last_completed_session
    QuizSession.where(user: current_user, quiz: @quiz).order(end_time: :desc).first
  end

  def end_existing_session
    existing_session = find_existing_session
    existing_session&.update(end_time: Time.current)
  end

  def find_next_question(last_answered_question_id)
    if last_answered_question_id
      @quiz.questions.where('questions.id > ?', last_answered_question_id).first
    else
      @quiz.questions.first
    end
  end
end

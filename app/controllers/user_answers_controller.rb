class UserAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz
  before_action :set_question

  def create
    @user_answer = build_user_answer

    if existing_answer
      redirect_to_existing_answer
    elsif @user_answer.save
      handle_answer_saving
    else
      handle_saving_failure
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def user_answer_params
    params.require(:user_answer).permit(:answer_text)
  end

  def last_question?
    @quiz.questions.where('questions.id > ?', @question.id).empty?
  end

  def current_quiz_session
    QuizSession.find_or_create_by(user: current_user, quiz: @quiz, end_time: nil) do |session|
      session.start_time = Time.current
    end
  end

  def build_user_answer
    @question.user_answers.build(user_answer_params).tap do |user_answer|
      user_answer.user = current_user
      user_answer.quiz = @quiz
      user_answer.quiz_session = current_quiz_session
    end
  end

  def existing_answer
    UserAnswer.find_by(user: current_user, question: @question, quiz_session: @user_answer.quiz_session)
  end

  def redirect_to_existing_answer
    redirect_to take_quiz_path(@quiz, question_id: @question.id), alert: I18n.t('alerts.already_answered')
  end

  def handle_answer_saving
    if last_question?
      current_quiz_session.update(end_time: Time.current)
      redirect_to results_quiz_path(@quiz), notice: I18n.t('notices.quiz_completed')
    else
      next_question = find_next_question
      redirect_to take_quiz_path(
        @quiz, question_id: next_question.id, resume_session: "false"
      ), notice: I18n.t('notices.answer_submitted')
    end
  end

  def handle_saving_failure
    @questions = @quiz.questions
    render "quizzes/take"
  end

  def find_next_question
    @quiz.questions.where('questions.id > ?', @question.id).first
  end
end

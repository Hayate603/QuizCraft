class UserAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz
  before_action :set_question

  def create
    @user_answer = @question.user_answers.build(user_answer_params)
    @user_answer.user = current_user
    @user_answer.quiz = @quiz
    @user_answer.quiz_session = current_quiz_session

    existing_answer = UserAnswer.find_by(user: current_user, question: @question, quiz_session: @user_answer.quiz_session)
    if existing_answer
      redirect_to take_quiz_path(@quiz, question_id: @question.id), alert: I18n.t('alerts.already_answered')
    elsif @user_answer.save
      if last_question?
        current_quiz_session.update(end_time: Time.current)
        redirect_to results_quiz_path(@quiz), notice: I18n.t('notices.quiz_completed')
      else
        next_question = @quiz.questions.where('questions.id > ?', @question.id).first
        redirect_to take_quiz_path(@quiz, question_id: next_question.id, resume_session: "false"), notice: I18n.t('notices.answer_submitted')
      end
    else
      @questions = @quiz.questions
      render "quizzes/take"
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
end

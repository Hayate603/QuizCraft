class UserAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz
  before_action :set_question

  def create
    @user_answer = @question.user_answers.build(user_answer_params)
    @user_answer.user = current_user
    @user_answer.quiz = @quiz
    @user_answer.quiz_session = current_quiz_session
    @user_answer.correct = @user_answer.answer_text == @question.correct_answer

    if @user_answer.save
      redirect_to next_question_path, notice: "Answer submitted!"
    else
      render "questions/show"
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

  def next_question_path
    # ロジックに応じて次の質問または結果ページへのパスを返す
  end

  def current_quiz_session
    # 現在のクイズセッションを取得するロジックを追加
  end
end

class QuizzesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update toggle_publish destroy take results start answer_question]
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
    if @quiz.questions.empty?
      redirect_to quiz_path(@quiz), alert: I18n.t('alerts.no_questions')
      return
    end

    quiz_progress = session[:quiz_progress]

    unless quiz_progress && quiz_progress["quiz_id"] == @quiz.id
      redirect_to quiz_path(@quiz), alert: I18n.t('alerts.session_not_found')
      return
    end

    answered_ids = quiz_progress["answers"].map { |a| a["question_id"] }
    @question = @quiz.questions.where.not(id: answered_ids).first

    if @question.nil?
      redirect_to results_quiz_path(@quiz)
      return
    end
  end

  def answer_question
    quiz_progress = session[:quiz_progress]

    unless quiz_progress && quiz_progress["quiz_id"] == @quiz.id
      redirect_to quiz_path(@quiz), alert: I18n.t('alerts.session_not_found')
      return
    end

    question = @quiz.questions.find(params[:question_id])
    correct = (params[:answer_text] == question.correct_answer)

    quiz_progress["answers"] << {
      "question_id" => question.id,
      "answer_text" => params[:answer_text],
      "correct" => correct
    }
    session[:quiz_progress] = quiz_progress

    redirect_to take_quiz_path(@quiz), notice: I18n.t('notices.answer_submitted')
  end

  def results
    quiz_progress = session[:quiz_progress]
    if quiz_progress && quiz_progress["quiz_id"] == @quiz.id && quiz_progress["answers"].present?
      @answers = quiz_progress["answers"]
      @correct_count = @answers.count { |answer| answer["correct"] }

      # 質問情報を取得し、question_idをキーにしたハッシュを作成
      question_data = @quiz.questions.pluck(:id, :question_text, :correct_answer).map do |id, q_text, c_answer|
        [id, { "question_text" => q_text, "correct_answer" => c_answer }]
      end.to_h

      # @answersにquestion_textとcorrect_answerを付与
      @answers.each do |answer|
        q_info = question_data[answer["question_id"]]
        answer["question_text"] = q_info["question_text"]
        answer["correct_answer"] = q_info["correct_answer"]
      end

      # クイズ完了後にセッションをクリア
      session.delete(:quiz_progress)
    else
      redirect_to quiz_path(@quiz), alert: I18n.t('alerts.no_completed_session')
    end
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

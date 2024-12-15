module QuizHelpers
  extend ActiveSupport::Concern

  # take関連メソッド
  def redirect_if_no_questions(quiz)
    return false unless quiz.questions.empty?

    redirect_to quiz_path(quiz), alert: I18n.t('alerts.no_questions')
    true
  end

  def redirect_unless_valid_session(quiz_progress, quiz)
    return false if quiz_progress && quiz_progress["quiz_id"] == quiz.id

    redirect_to quiz_path(quiz), alert: I18n.t('alerts.session_not_found')
    true
  end

  def assign_next_question(quiz_progress, quiz)
    answered_ids = quiz_progress["answers"].pluck("question_id")
    quiz.questions.where.not(id: answered_ids).first
  end

  # answer_question関連メソッド
  def valid_session?(quiz_progress, quiz)
    quiz_progress && quiz_progress["quiz_id"] == quiz.id
  end

  def redirect_to_invalid_session(quiz)
    redirect_to quiz_path(quiz), alert: I18n.t('alerts.session_not_found')
  end

  def process_answer(quiz_progress, question_id, answer_text, quiz)
    question = quiz.questions.find(question_id)
    correct = (answer_text == question.correct_answer)

    quiz_progress["answers"] << {
      "question_id" => question.id,
      "answer_text" => answer_text,
      "correct" => correct
    }
    session[:quiz_progress] = quiz_progress
  end

  # results関連メソッド
  def valid_results_session?(quiz_progress, quiz)
    quiz_progress && quiz_progress["quiz_id"] == quiz.id && quiz_progress["answers"].present?
  end

  def redirect_to_no_completed_session(quiz)
    redirect_to quiz_path(quiz), alert: I18n.t('alerts.no_completed_session')
  end

  def prepare_results(quiz_progress, quiz)
    @answers = quiz_progress["answers"]
    @correct_count = @answers.count { |answer| answer["correct"] }
    question_data = fetch_question_data(quiz)
    enrich_answers_with_question_data(@answers, question_data)
  end

  def fetch_question_data(quiz)
    quiz.questions.pluck(:id, :question_text, :correct_answer).to_h do |id, q_text, c_answer|
      [id, { "question_text" => q_text, "correct_answer" => c_answer }]
    end
  end

  def enrich_answers_with_question_data(answers, question_data)
    answers.each do |answer|
      q_info = question_data[answer["question_id"]]
      answer["question_text"] = q_info["question_text"]
      answer["correct_answer"] = q_info["correct_answer"]
    end
  end

  def clear_quiz_session
    session.delete(:quiz_progress)
  end
end

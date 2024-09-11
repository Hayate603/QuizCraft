module QuestionsHelper
  def fetch_questions_params
    questions_data = JSON.parse(params[:questions_data])['questions']
    questions_data.map do |q|
      ActionController::Parameters.new(q).permit(:question_text, :correct_answer)
    end
  end
end

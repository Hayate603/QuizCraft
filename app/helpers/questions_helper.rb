module QuestionsHelper
  def fetch_questions_params
    questions_data = JSON.parse(params[:questions_data])['questions']
    questions_data.map do |q|
      ActionController::Parameters.new(q).permit(:question_text, :correct_answer)
    end
  end

  def save_questions(questions_params, quiz)
    success_questions = []
    failed_questions = []

    questions_params.each do |question_param|
      question = build_question(question_param, quiz)
      save_question(question, success_questions, failed_questions)
    end

    [success_questions, failed_questions]
  end

  def parse_response(response)
    questions_and_answers = response["choices"][0]["message"]["content"].split("\n").reject(&:empty?)

    questions_and_answers.each_slice(2).filter_map do |question, answer|
      next if question.nil? || answer.nil?

      {
        question: question.sub("Q: ", ""),
        answer: answer.sub("A: ", "")
      }
    end
  end

  def fetch_openai_response(client, extracted_text)
    client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "あなたは優秀なクイズ作成者です。" },
          {
            role: "user",
            content: <<~TEXT
              以下のテキストに基づいてクイズの質問とその正解を作成してください。
              - 質問は重要なポイントに基づいて作成し、テキストの内容に沿ったものであることを確認してください。
              - 各質問と回答はそれぞれ'Q: 'と'A: 'で始まるようにし、改行で区切ってください。
              - 質問はできるだけ多く作成してください。
              - 具体的な事実や定義を問う質問を含めてください。
              - 各質問の正確な回答を提供してください。
              - 回答は単語で答えられる形式にしてください。

              テキスト:
              #{extracted_text}
            TEXT
          }
        ],
        max_tokens: 1000,
        n: 1
      }
    )
  end

  private

  def build_question(question_param, quiz)
    question = Question.new(question_param)
    question.quizzes << quiz
    question
  end

  def save_question(question, success_questions, failed_questions)
    if question.save
      success_questions << { question_text: question.question_text, correct_answer: question.correct_answer }
    else
      failed_questions << { errors: question.errors.full_messages, question_text: question.question_text,
                            correct_answer: question.correct_answer }
    end
  end
end

module QuestionsHelper
  def fetch_questions_params
    params.require(:questions).map do |q|
      q.permit(:question_text, :correct_answer)
    end
  end

  def save_questions(questions_params, quiz)
    errors = questions_params.flat_map do |question_param|
      save_single_question(question_param, quiz)
    end

    [errors.empty?, errors]
  end

  def save_single_question(question_param, quiz)
    question = Question.new(question_param)
    question.quizzes << quiz
    question.save ? [] : question.errors.full_messages
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
end

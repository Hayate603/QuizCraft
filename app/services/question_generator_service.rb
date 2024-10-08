class QuestionGeneratorService
  def initialize(image = nil, extracted_text = nil)
    @image = image
    @extracted_text = extracted_text
  end

  def generate_from_image
    vision = Google::Cloud::Vision.image_annotator
    response = vision.text_detection(image: @image.tempfile)
    response.responses.first.text_annotations.first.description
  end

  # rubocop:disable Metrics/MethodLength
  def generate_from_text
    client = OpenAI::Client.new
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
              #{@extracted_text}
            TEXT
          }
        ],
        max_tokens: 1000,
        n: 1
      }
    )
  end
  # rubocop:enable Metrics/MethodLength
end

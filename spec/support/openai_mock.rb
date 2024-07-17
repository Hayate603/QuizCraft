require 'openai'

RSpec.configure do |config|
  config.before(:each) do
    mock_openai_client = instance_double(OpenAI::Client)
    allow(OpenAI::Client).to receive(:new).and_return(mock_openai_client)
    allow(mock_openai_client).to receive(:chat).and_return(mock_openai_response)
  end

  def mock_openai_response
    OpenStruct.new(
      choices: [
        OpenStruct.new(
          message: OpenStruct.new(
            content: "Q: Mocked question?\nA: Mocked answer"
          )
        )
      ]
    )
  end
end


require 'google/cloud/vision/v1'

RSpec.configure do |config|
  config.before(:each) do
    mock_vision_client = instance_double(Google::Cloud::Vision::V1::ImageAnnotator::Client)
    allow(Google::Cloud::Vision::V1::ImageAnnotator::Client).to receive(:new).and_return(mock_vision_client)
    allow(mock_vision_client).to receive(:text_detection).and_return(mock_text_detection_response)
  end

  def mock_text_detection_response
    response = Google::Cloud::Vision::V1::AnnotateImageResponse.new
    text_annotation = Google::Cloud::Vision::V1::EntityAnnotation.new(description: "mocked text")
    response.text_annotations << text_annotation
    Google::Cloud::Vision::V1::BatchAnnotateImagesResponse.new(responses: [response])
  end
end

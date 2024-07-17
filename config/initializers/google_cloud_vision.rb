require "google/cloud/vision"

Google::Cloud::Vision.configure do |config|
  config.credentials = Rails.root.join("service-account-key.json").to_s
end

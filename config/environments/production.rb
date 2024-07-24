require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  # config.require_master_key = true

  # アセットプリコンパイル設定
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.assets.precompile += %w( .svg .eot .woff .ttf )
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # 静的ファイルの提供
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # アセットホスト
  # config.asset_host = "http://assets.example.com"

  # ファイル送信ヘッダー
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # SSL設定
  # config.assume_ssl = true
  config.force_ssl = true

  # ログ設定
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # キャッシュストアの設定
  # config.cache_store = :mem_cache_store

  # メール設定
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'example.com',
    user_name:            '<username>',
    password:             '<password>',
    authentication:       'plain',
    enable_starttls_auto: true
  }

  config.active_storage.service = :local
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false

  # Active Jobの設定
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "quizcraft_production"

  # Action Cableの設定
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # ホストの設定
  # config.hosts = [ "example.com", /.*\.example\.com/ ]
end

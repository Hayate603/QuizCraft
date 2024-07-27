require "active_support/core_ext/integer/time"

Rails.application.configure do
  # コードの再読み込みを無効にし、Eager Load を有効にする
  config.enable_reloading = false
  config.eager_load = true

  # 詳細なエラーメッセージを無効にする
  config.consider_all_requests_local = false

  # キャッシュを有効にする
  config.action_controller.perform_caching = true

  # アセットプリコンパイル設定
  config.assets.js_compressor = :terser
  config.assets.compile = true
  config.assets.digest = true
  config.assets.precompile += %w( application.js application.scss )
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # SSL設定
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

  # メール設定
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'quiz-craft-new-6bafbe70ad3e.herokuapp.com',
    user_name:            ENV['GMAIL_USERNAME'], # 環境変数を使用
    password:             ENV['GMAIL_PASSWORD'], # 環境変数を使用
    authentication:       'plain',
    enable_starttls_auto: true
  }
  config.action_mailer.default_url_options = {
    host: 'quiz-craft-new-6bafbe70ad3e.herokuapp.com', # ここにHerokuアプリのドメイン名を入力
    protocol: 'https'
  }

  # アクティブストレージ設定
  config.active_storage.service = :local

  # 国際化（i18n）設定
  config.i18n.fallbacks = true

  # 非推奨警告の報告を無効にする
  config.active_support.report_deprecations = false

  # マイグレーション後にスキーマをダンプしない
  config.active_record.dump_schema_after_migration = false

  # Active Jobの設定（例: Sidekiq を使用する場合）
  # config.active_job.queue_adapter = :sidekiq
  # config.active_job.queue_name_prefix = "quizcraft_production"

  # Action Cableの設定
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # ホストの設定
  config.hosts << "quiz-craft-new-6bafbe70ad3e.herokuapp.com"
end

SlackRubyBotServer.configure do |config|
  config.oauth_version = :v2
  config.oauth_scope = %w[
    commands
    incoming-webhook
  ]

  stdout_logger = Logger.new(STDOUT, level: Logger::DEBUG)
  file_logger = Logger.new("log/#{ENV['RACK_ENV']}.log", level: Logger::INFO)

  config.logger = ActiveSupport::BroadcastLogger.new(stdout_logger, file_logger)
end

# frozen_string_literal: true

SlackRubyBotServer.configure do |config|
  config.oauth_version = :v2
  config.oauth_scope = %w[users:read channels:read channels:join groups:read chat:write commands incoming-webhook]
  config.logger = Logger.new("log/#{ENV['RACK_ENV']}.log")
end

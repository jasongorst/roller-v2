# frozen_string_literal: true

SlackRubyBotServer.configure do |config|
  config.oauth_version = :v2
  config.oauth_scope = %w[users:read channels:read groups:read chat:write commands incoming-webhook]
end

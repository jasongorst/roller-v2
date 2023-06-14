# frozen_string_literal: true

SlackRubyBotServer::Events.configure do |config|
  config.on :command do |command|
    command.logger.info "Received #{command[:command]}."
    command.logger.debug command
    nil
  end
end

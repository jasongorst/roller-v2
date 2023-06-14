# frozen_string_literal: true

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/coin' do |command|
    command.logger.info "Command:\n#{command}"
    command.logger.info 'Flipping a coin.'

    token = ENV['BOT_USER_OAUTH_TOKEN']
    slack_client = Slack::Web::Client.new(token: token)

    flip = %w[Heads Tails].sample
    slack_client.chat_postMessage(
      channel: command[:channel_id],
      blocks: [
        { type: 'section',
          text: { type: 'mrkdwn',
                  text: "<@#{command[:user_id]}> flips a coin." }
        },
        { type: 'section',
          fields: [{ type: 'mrkdwn',
                     text: "*Result:*\n#{flip}!" }]
        }
      ]
    )

    { ok: true }
  end
end

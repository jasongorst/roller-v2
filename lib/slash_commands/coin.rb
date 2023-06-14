# frozen_string_literal: true

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/coin' do |command|
    command.logger.info 'Flipping a coin.'

    token = ENV['BOT_USER_OAUTH_TOKEN']
    slack_client = Slack::Web::Client.new(token: token)

    slack_client.conversations_join(channel: command[:channel_id])

    flip = %w[Heads Tails].sample
    slack_client.chat_postMessage(
      channel: command[:channel_id],
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "<@#{command[:user_id]}> flips a coin #{command[:text]}."
          },
          fields: [
            {
              type: 'mrkdwn',
              text: "*Result*\n#{flip}!"
            }
          ]
        }
      ]
    )

    nil
  end
end

# frozen_string_literal: true

require_relative '../roller/dice'

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/dice' do |command|
    command.logger.info 'Rolling some dice.'

    token = ENV['BOT_USER_OAUTH_TOKEN']
    slack_client = Slack::Web::Client.new(token: token)

    slack_client.conversations_join(channel: command[:channel_id])

    dice = begin
      Roller::Dice.parse(command[:text]).roll
    rescue ArgumentError
      "Invalid dice notation #{command[:text]}"
    end

    slack_client.chat_postMessage(
      channel: command[:channel_id],
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "<@#{command[:user_id]}> rolls *#{dice.number}d#{dice.sides}#{dice.modifier}."
          },
          fields: [
            # headers
            {
              type: 'mrkdwn',
              text: '*Rolls*'
            },
            {
              type: 'mrkdwn',
              text: '*Total*'
            },
            # details
            {
              type: 'plain_text',
              text: dice.rolls.to_s
            },
            {
              type: 'plain_text',
              text: dice.total
            }
          ]
        }
      ]
    )

    nil
  end
end

# frozen_string_literal: true

require_relative '../roller/wod'

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/roll' do |command|
    command.logger.info 'Rolling some dice (like WoD).'

    token = ENV['BOT_USER_OAUTH_TOKEN']
    slack_client = Slack::Web::Client.new(token: token)

    slack_client.conversations_join(channel: command[:channel_id])

    dice = begin
      Roller::WoD.parse(command[:text]).roll
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
            text: "<@#{command[:user_id]}> rolls *#{dice.number}* dice (diff *#{dice.difficulty}*)."
          },
          fields: fields(dice)
        }
      ]
    )

    nil
  end
end

def result(dice)
  if dice.botch?
    '_BOTCH!_'
  elsif dice.failure?
    'Failure'
  else
    "Successes: *#{dice.check}*"
  end
end

def fields(dice)
  if dice.extra_rolls.empty?
    [
      {
        type: 'mrkdwn',
        text: '*Rolls*'
      },
      {
        type: 'mrkdwn',
        text: '*Result*'
      },
      {
        type: 'plain_text',
        text: dice.rolls.to_s
      },
      {
        type: 'mrkdwn',
        text: result(dice)
      }
    ]
  else
    [
      {
        type: 'mrkdwn',
        text: '*Rolls*'
      },
      {
        type: 'mrkdwn',
        text: '*Extra Rolls*'
      },
      {
        type: 'plain_text',
        text: dice.rolls.to_s
      },
      {
        type: 'plain_text',
        text: dice.extra_rolls.to_s
      },
      {
        type: 'mrkdwn',
        text: '*Result*'
      },
      {
        type: 'mrkdwn',
        text: result(dice)
      }
    ]
  end
end

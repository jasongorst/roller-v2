# frozen_string_literal: true

require_relative '../roller/dice'

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/dice' do |command|
    command.logger.info 'Rolling some dice.'

    team = Team.where(team_id: command[:team_id]).first || raise("Cannot find team with ID #{command[:team_id]}.")
    slack_client = Slack::Web::Client.new(token: team.token)
    slack_client.conversations_join(channel: command[:channel_id])

    begin
      roll = Roller::Dice.parse(command[:text]).roll

      slack_client.chat_postMessage(
        channel: command[:channel_id],
        blocks: [
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: "<@#{command[:user_id]}> rolls *#{roll.number}d#{roll.sides}#{roll.modifier}*."
            },
            fields: [
              {
                type: 'mrkdwn',
                text: '*Rolls*'
              },
              {
                type: 'mrkdwn',
                text: '*Total*'
              },
              {
                type: 'plain_text',
                text: roll.rolls.to_s
              },
              {
                type: 'plain_text',
                text: roll.total.to_s
              }
            ]
          }
        ]
      )
    rescue ArgumentError
      raise "Invalid dice notation #{command[:text]}"
    end

    nil
  end
end

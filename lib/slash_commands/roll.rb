# frozen_string_literal: true

require_relative '../roller/wod'

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/roll' do |command|
    command.logger.info 'Rolling some dice (like WoD).'

    team = Team.where(team_id: command[:team_id]).first || raise("Cannot find team with ID #{command[:team_id]}.")
    slack_client = Slack::Web::Client.new(token: team.token)
    slack_client.conversations_join(channel: command[:channel_id])

    begin
      roll = Roller::WoD.parse(command[:text]).roll

      slack_client.chat_postMessage(
        channel: command[:channel_id],
        blocks: [{ type: 'section',
                   text: { type: 'mrkdwn',
                           text: "<@#{command[:user_id]}> rolls *#{roll.number}* dice (diff *#{roll.difficulty}*)." },
                   fields: fields(roll) }]
      )
    rescue ArgumentError
      raise "Invalid dice notation #{command[:text]}"
    end

    nil
  end
end

def fields(roll)
  if roll.extra_rolls.empty?
    [{ type: 'mrkdwn', text: '*Rolls*' },
     { type: 'mrkdwn', text: '*Result*' },
     { type: 'plain_text', text: roll.rolls.to_s },
     { type: 'mrkdwn', text: result(roll) }]
  else
    [{ type: 'mrkdwn', text: '*Rolls*' },
     { type: 'mrkdwn', text: '*Extra Rolls*' },
     { type: 'plain_text', text: roll.rolls.to_s },
     { type: 'plain_text', text: roll.extra_rolls.to_s },
     { type: 'mrkdwn', text: '*Result*' },
     { type: 'plain_text', text: ' ' },
     { type: 'mrkdwn', text: result(roll) }]
  end
end

def result(roll)
  if roll.botch?
    '_BOTCH!_'
  elsif roll.failure?
    'Failure'
  else
    "Successes: *#{roll.check}*"
  end
end

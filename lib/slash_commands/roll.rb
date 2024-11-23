require_relative '../roller/world_of_darkness'

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/roll' do |command|
    command.logger.info 'Rolling some dice (WoD-style).'

    begin
      roll = Roller::WorldOfDarkness.parse(command[:text]).roll

      {
        response_type: "in_channel",
        attachments: [
          {
            color: color(roll),
            blocks: [{
                       type: 'section',
                       text: {
                         type: 'mrkdwn',
                         text: "<@#{command[:user_id]}> rolls *#{roll.number}* dice (diff *#{roll.difficulty}*)#{' with exploding 10s' if roll.explode}."
                       },
                       fields: fields(roll)
                     }]
          }
        ]
      }
    rescue ArgumentError
      {
        response_type: "ephemeral",
        text: "Sorry, I can't figure out how to /roll #{command[:text]}."
      }
    end
  end
end

def fields(roll)
  if roll.extra_rolls.empty?
    [
      { type: 'mrkdwn', text: "*Rolls*\n#{roll.rolls.to_s}" },
      { type: 'mrkdwn', text: "*Result*\n#{result(roll)}" }
    ]
  else
    [
      { type: 'mrkdwn', text: "*Rolls*\n#{roll.rolls.to_s}" },
      { type: 'mrkdwn', text: "*Extra Rolls*\n#{roll.extra_rolls.to_s}" },
      { type: 'mrkdwn', text: "*Result*\n#{result(roll)}" }
    ]
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

def color(roll)
  if roll.botch?
    # danger
    'a30200'
  elsif roll.failure?
    # warning
    'daa038'
  else
    # good
    '#2eb886'
  end
end

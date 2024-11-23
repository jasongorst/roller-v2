require_relative '../roller/normal_dice'

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/dice' do |command|
    command.logger.info 'Rolling some dice.'

    begin
      roll = Roller::NormalDice.parse(command[:text]).roll

      {
        response_type: "in_channel",
        attachments: [
          {
            color: "#2eb886",
            blocks: [{
                       type: 'section',
                       text: {
                         type: 'mrkdwn',
                         text: "<@#{command[:user_id]}> rolls *#{roll.number}d#{roll.sides}#{roll.modifier}*."
                       },
                       fields: [
                         { type: 'mrkdwn', text: "*Rolls*\n#{roll.rolls.to_s}" },
                         { type: 'mrkdwn', text: "*Total*\n#{roll.total.to_s}" }
                       ]
                     }]
          }
        ]
      }
    rescue ArgumentError
      {
        response_type: "ephemeral",
        text: "Sorry, I can't figure out \"#{command[:text]}\"."
      }
    end
  end
end

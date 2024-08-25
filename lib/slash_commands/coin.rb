SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/coin' do |command|
    command.logger.info 'Flipping a coin.'

    flip = if rand < 1.0e-4
             "The coin lands balanced on its edge. Spooky."
           else
             %w[Heads Tails].sample
           end

    {
      response_type: "in_channel",
      attachments: [
        {
          blocks: [{
                     type: 'section',
                     text: { type: 'mrkdwn', text: "<@#{command[:user_id]}> flips a coin." },
                     fields: [{ type: 'mrkdwn', text: "*Result*\n#{flip}!" }]
                   }]
        }
      ]
    }
  end
end

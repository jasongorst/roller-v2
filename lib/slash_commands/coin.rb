# frozen_string_literal: true

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/coin' do |command|
    command.logger.info 'Flipping a coin.'
    flip = %w[Heads Tails].sample

    {
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: 'Someone flips a coin.'
          }
        },
        {
          type: 'section',
          fields: [
            {
              type: 'mrkdwn',
              text: "*Result:*\n#{flip}!"
            }
          ]
        }
      ]
    }
  end
end

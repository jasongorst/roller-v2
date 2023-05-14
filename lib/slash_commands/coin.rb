# frozen_string_literal: true

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/coin' do |command|
    command.logger.info 'Flipping a coin.'
    flip = %w[Heads Tails].sample

    {
      text: "<@#{data.user_name}> flips a coin #{text}",
      fields: [
        {
          title: 'Result',
          value: "#{flip}!",
          short: true
        }
      ],
      mrkdwn_in: ['text'], color: 'good'
    }
  end
end

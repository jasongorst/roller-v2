# frozen_string_literal: true

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/coin' do |command|
    command.logger.info 'Flipping a coin.'

    team = Team.where(team_id: command[:team]) || raise("Cannot find team with ID #{command[:team]}.")

    slack_client = Slack::Web::Client.new(token: team.token)

    flip = %w[Heads Tails].sample
    slack_client.chat_postMessage(
      channel: command[:channel],
      blocks: [
        { type: 'section',
          text: { type: 'mrkdwn',
                  text: "<@#{command[:user]}> flips a coin." }
        },
        { type: 'section',
          fields: [{ type: 'mrkdwn',
                     text: "*Result:*\n#{flip}!" }]
        }
      ]
    )

    { ok: true }
  end
end

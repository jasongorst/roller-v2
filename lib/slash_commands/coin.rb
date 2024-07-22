# frozen_string_literal: true

SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/coin' do |command|
    command.logger.info 'Flipping a coin.'

    team = Team.where(team_id: command[:team_id]).first || raise("Cannot find team with ID #{command[:team_id]}.")
    slack_client = Slack::Web::Client.new(token: team.token)
    slack_client.conversations_join(channel: command[:channel_id])

    flip = if rand < 1.0e-4
             "The coin lands balanced on its edge. Spooky."
           else
             %w[Heads Tails].sample
           end

    slack_client.chat_postMessage(
      channel: command[:channel_id],
      blocks: [{ type: 'section',
                 text: { type: 'mrkdwn', text: "<@#{command[:user_id]}> flips a coin." },
                 fields: [{ type: 'mrkdwn', text: "*Result*\n#{flip}!" }] }]
    )

    nil
  end
end

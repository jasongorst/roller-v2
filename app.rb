# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'development'

require 'active_record' # required for slack-ruby-bot-server-events
require 'bundler/setup'

Bundler.require :default

Dotenv.load '.env.production'

Dir[File.expand_path('config/initializers', __dir__) + '/*.rb'].sort.each do |file|
  require file
end

require_relative 'lib/models'
require_relative 'lib/slash_commands'

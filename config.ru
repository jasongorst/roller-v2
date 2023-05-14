# frozen_string_literal: true

require_relative 'app'

yml = ERB.new(File.read(File.expand_path('config/database.yml', __dir__))).result
db_config = ::YAML.safe_load(yml, aliases: true)[ENV['RACK_ENV']]

ActiveRecord::Base.establish_connection(db_config)

SlackRubyBotServer::App.instance.prepare!
SlackRubyBotServer::Service.start!

run SlackRubyBotServer::Api::Middleware.instance

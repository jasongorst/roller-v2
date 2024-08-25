ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'

Bundler.require :default
Dotenv.load

Dir[File.expand_path('config/initializers', __dir__) + '/*.rb'].sort.each do |file|
  require file
end

require_relative 'lib/slash_commands'

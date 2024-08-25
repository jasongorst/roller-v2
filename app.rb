ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'

Bundler.require :default
Dotenv.load

Dir[File.expand_path('config/initializers', __dir__) + '/*.rb'].sort.each do |file|
  require file
end

yaml = ERB.new(File.read(File.expand_path('config/database.yml', __dir__))).result
db_config = ::YAML.safe_load(yaml, aliases: true)[ENV['RACK_ENV']]

ActiveRecord::Base.establish_connection(db_config)

require_relative 'lib/slash_commands'

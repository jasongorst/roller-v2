source "https://gem.coop"

ruby file: ".ruby-version"

# activerecord must load before slack-ruby-bot-server
gem "activerecord", "~> 7.1", "< 7.2", require: "active_record"

gem "slack-ruby-bot-server", "~> 2.2"
gem "slack-ruby-bot-server-events", "~> 0.4"

gem "rack", "~> 2.2", "< 3.0"
gem "puma", "~> 6.6"

group :development do
  gem "bcrypt_pbkdf", "~> 1.1", "< 2.0"
  gem "ed25519", "~> 1.4", "< 2.0"
  gem "mina", "~> 1.2"
  gem "mina-version_managers", "~> 0.1"
  gem "net-scp", "~> 4.1"
end

# database
gem "mysql2", "~> 0.5"
gem "otr-activerecord", "~> 2.5"
gem "pagy_cursor", "~> 0.8"

# additional
gem "dotenv", "~> 3.1"
gem "activesupport", "~> 7.1", "< 7.2", require: "active_support/broadcast_logger"

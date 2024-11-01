source "https://rubygems.org"

ruby file: ".ruby-version"

# activerecord must load before slack-ruby-bot-server
gem "activerecord", "~> 7.1.3.4", "< 7.2", require: "active_record"

gem "slack-ruby-bot-server", "~> 2.1.1"
gem "slack-ruby-bot-server-events", "~> 0.3.2"

gem "rack", "~> 2.2.9", "< 3.0"
gem "puma", "~> 6.4.2"

group :development do
  gem "bcrypt_pbkdf", "~> 1.1.1", "< 2.0"
  gem "ed25519", "~> 1.3.0", "< 2.0"
  gem "mina", "~> 1.2.5"
  gem "mina-version_managers", "~> 0.1.0"
  gem "net-scp", "~> 4.0.0"
end

# database
gem "mysql2", "~> 0.5.6"
gem "otr-activerecord", "~> 2.4.0"
gem "pagy_cursor", "~> 0.6.1"

# additional
gem "dotenv", "~> 3.1.2"
gem "activesupport", "~> 7.1.3.4", "< 7.2", require: "active_support/broadcast_logger"

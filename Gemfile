source 'https://rubygems.org'
gem "activeadmin", "~> 2.9"
gem "activeadmin_addons", "~> 2.0.0.beta.0"
gem "aws-sdk-s3", "~> 1.0"
gem "blurhash", "~> 0.1"
gem "bootsnap", require: false
gem "bullet"
gem "data_migrate"
gem "devise"
gem "devise-i18n"
gem "draper", "~> 3.1"
gem "image_processing", "~> 1.8"
gem "jbuilder"
gem "marcel", "~> 1.0"
gem "mjml-rails"
gem "pg"
gem "power_api", "~> 2.0"
gem "power-types"
gem "puma", "~> 5.0"
gem "pundit"
gem "rack-cors", "~> 1.1"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "rails-i18n"
gem "recipient_interceptor"
gem "redis-actionpack"
gem "ruby-vips", "~> 2.1"
gem "sassc", github: "sass/sassc-ruby", ref: "refs/pull/233/head"
gem "sassc-embedded"
gem "scout_apm"
gem "send_grid_mailer"
gem "sentry-rails"
gem "shrine", "~> 3.0"
gem "sidekiq"
gem "sidekiq-scheduler", ">= 3.0.1"
gem "sprockets-rails"
gem "strong_migrations"
gem "vite_rails"

group :development do
  gem "annotate", "~> 3.0"
  gem "listen"
  gem "spring"
end

group :production do
  gem "heroku-stage"
  gem "rack-timeout"
end

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "brakeman"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "guard-rspec", require: false
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-nc", require: false
  gem "rspec-rails"
  gem "rswag-specs"
  gem "rubocop", "~> 1.9"
  gem "rubocop-performance"
  gem "rubocop-platanus"
  gem "rubocop-rails"
  gem "rubocop-rspec", "~> 2.2"
end

group :test do
  gem "capybara"
  gem "rspec_junit_formatter", "~> 0.4"
  gem "shoulda-matchers", require: false
  gem "simplecov"
  gem "simplecov_linter_formatter", "~> 0.2"
  gem "simplecov_text_formatter"
  gem "webdrivers"
end

group :production, :development, :test do
  gem "tzinfo-data"
end

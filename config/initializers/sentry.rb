if Rails.env.production?
  Sentry.init do |config|
    config.environment = Heroku.stage
  end
end

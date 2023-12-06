require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)
# require_relative '../lib/dotenv_monkeypatch'

module Windie
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/public/*', headers: :any, methods: :get
        resource '/api/*',
                 headers: :any,
                 expose: ['X-Page', 'X-PageTotal'],
                 methods: [:get, :post, :patch, :put, :delete, :options]
      end
    end

    config.before_configuration do
      require Rails.root.join('lib/environment_variables.rb')
      require Rails.root.join('lib/twilio_constants.rb')
      require Rails.root.join('lib/windguru_locations.rb')
      require Rails.root.join('lib/whatsapp_messages.rb')
    end
    config.i18n.fallbacks = [:es, :en]
    config.i18n.default_locale = 'es-CL'
    config.active_job.queue_adapter = :sidekiq
    config.assets.paths << Rails.root.join('node_modules')
    config.load_defaults 7.0
  end
end

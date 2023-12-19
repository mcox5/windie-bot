Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      namespace :webhook do
        post 'twilio_whatsapp_chat', to: 'chat#handle_user_chat'
      end
    end
  end
  devise_for :users
  mount Sidekiq::Web => '/queue'
end

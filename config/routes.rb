require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  scope :api do
    scope :v1 do
      namespace :convert do
        post :upload
        get :status
        get :download
      end
    end
  end
end

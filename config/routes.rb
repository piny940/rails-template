# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#show'

  namespace :admin do
    resource to: 'homes#show'
  end

  namespace :api, defaults: { format: :json } do
    resource :csrf, only: %i[show]
    resource :session, only: %i[create destroy]
  end
end

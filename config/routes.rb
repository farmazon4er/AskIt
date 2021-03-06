# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[new create edit update]
  resource :session, only: %i[new create destroy]

  resources :questions do
    resources :answers, only: %i[create destroy edit update]
  end

  namespace :admin do
    resources :users, only: %i[index create]
  end

  root 'pages#index'
end

# frozen_string_literal: true

Rails.application.routes.draw do
  resources :user_accounts, only: [:create]
end

# frozen_string_literal: true

Rails.application.routes.draw do
  resources :user_accounts, only: [:create] do
    collection do
      get 'list_indications', to: :list_indications
    end
  end
end

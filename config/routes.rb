require "api_constraints"

Contactlist::Application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json },
                  path: "/api/" do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy]
      post "auth/login", to: "sessions#create"
      get "auth/logout", to: "sessions#destroy"

      resources :customers, only: [:index, :create, :update, :destroy, :show] do
        resources :transactions, only: [:create, :update]
      end

      resources :transactions, only: [:index, :show, :destroy]

    end
  end
end

require "api_constraints"

Contactlist::Application.routes.draw do
  root to: 'welcome#index'
  devise_for :users
  namespace :api, defaults: { format: :json } do
    scope "(:module)",
          module: :v1,
          defaults: { path: :v1 },
          constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy]
      post "auth/login", to: "sessions#create"
      get "auth/logout", to: "sessions#destroy"
      get "stats/total", to: "stats#total"
      get "stats/month", to: "stats#month"
      get "stats/customers", to: "stats#customers"

      resources :customers do
        resources :transactions, only: [:create, :update, :index, :show]
      end

      resources :transactions, only: [:index, :destroy]
    end
  end
  get "*unmatched_route", to: "application#no_route_found"
  put "*unmatched_route", to: "application#no_route_found"
  patch "*unmatched_route", to: "application#no_route_found"
  post "*unmatched_route", to: "application#no_route_found"
  delete "*unmatched_route", to: "application#no_route_found"
end

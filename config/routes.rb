Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :platforms, only: [ :index ]
  resources :purchases, only: [ :new, :create ]
  resources :products, only: [ :show, :index ]
  resources :users, only: [ :update ]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  get '/settings', to: 'users#edit', as: 'edit'
  patch '/settings', to: 'users#update', as: 'update'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get '/search/:query', to: 'products#search'
      get '/products/:id', to: 'products#fetch_price'
      get '/valuations/:current_user_id', to: 'valuations#fetch_total'
    end
  end
  # sidekiq
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  # chartkick renders
  namespace :charts do
    get 'valuation_history'
    get 'stock_price_history/:id', action: 'stock_price_history', as: 'stock_price_history'
  end
  #bitflyer connection
  get '/bitflyer_connect', to: 'users#connect_to_bitflyer', as: 'bitflyer_connect'
  # post '/purchases', to: 'purchases#order_through_bitflyer', as: 'bitflyer_order'
end

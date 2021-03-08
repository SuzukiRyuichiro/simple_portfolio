Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :platforms, only: [:index]
  resources :purchases, only: [ :new, :create ]
  resources :products, only: [ :show, :index ]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  get '/settings', to: 'users#edit', as: 'edit'
  patch '/settings', to: 'users#update', as: 'update'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get '/search/:query', to: 'products#search'
      get '/products/:id', to: 'products#fetch_price'
    end
  end
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  namespace :charts do
    get 'valuation_history'
    get 'stock_price_history/:id', action: 'stock_price_history', as: 'stock_price_history'
  end
end

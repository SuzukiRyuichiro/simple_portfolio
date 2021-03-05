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
    end
  end
  namespace :charts do
    get 'valuation_history'
  end
end

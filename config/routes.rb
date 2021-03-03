Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :platforms, only: [:index]
  resources :purchases, only: [ :new, :create ]

  resources :products, only: [ :show ]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  get '/settings', to: 'users#edit', as: 'edit'
  patch '/settings', to: 'users#update', as: 'update'
end

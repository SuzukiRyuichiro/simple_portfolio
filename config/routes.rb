Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  get '/products/:id', to: 'products#show', as: 'show'
  get '/purchases/:id/new', to: 'purchases#new', as: 'new'
  post '/purchases/:id', to: 'purchases#create', as: 'create'
  patch '/settings', to: 'users#update', as: 'update'
end

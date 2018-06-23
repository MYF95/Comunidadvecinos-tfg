Rails.application.routes.draw do
  devise_for :users

  root                      to: 'static_pages#home'
  get '/help',              to: 'static_pages#help'
  get '/about',             to: 'static_pages#about'

  get '/statements/import', to: 'statements#import'

  resources :apartments
  resources :statements
  resources :transactions
  resources :pending_payments
  resources :users
end

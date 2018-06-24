Rails.application.routes.draw do
  devise_for :users

  root                                  to: 'static_pages#home'
  get '/help',                          to: 'static_pages#help'
  get '/about',                         to: 'static_pages#about'

  get '/statements/import',             to: 'statements#import'
  get '/statements/:id/new_movement',   to: 'movements#new', as: 'new_statement_movement'
  post '/statements/:id/new_movement',  to: 'movements#create_for_statement', as: 'create_statement_movement'

  resources :apartments
  resources :statements
  resources :movements
  resources :pending_payments
  resources :users
end

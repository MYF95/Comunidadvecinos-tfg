Rails.application.routes.draw do
  devise_for :users

  root                                            to: 'static_pages#home'
  get '/help',                                    to: 'static_pages#help'
  get '/about',                                   to: 'static_pages#about'

  # User custom routes
  get '/profile/:id',                             to: 'users#show', as: 'user'
  get '/:id/users',                               to: 'users#index', as: 'userlist'

  # Statement with movement routes
  get '/statements/import',                       to: 'statements#import'
  get '/statements/:id/new_movement',             to: 'movements#new', as: 'new_statement_movement'
  post '/statements/:id/new_movement',            to: 'movements#create_for_statement', as: 'create_statement_movement'
  get '/statements/:id/:id_movement/divide',      to: 'movements#divide', as: 'divide'
  patch '/statements/:id/:id_movement/divide',    to: 'movements#divide_movement', as: 'divide_movement'

  # Apartment with user routes
  get '/apartments/:id/users',                    to: 'apartments#users', as: 'apartment_users'
  get '/apartments/:id/users/:user_id',           to: 'apartments#add_user', as: 'add_user'
  delete '/apartments/:id/users/:user_id',        to: 'apartments#remove_user', as: 'remove_user'

  # Apartment with movement routes
  get '/apartments/:id/movements',                to: 'apartments#movements', as: 'apartment_movements'
  get '/movements/:id/apartments',                to: 'movements#apartments', as: 'apartmentlist'
  get '/movements/:id/apartments/:apartment_id',  to: 'movements#associate_apartment', as: 'associate_apartment'

  resources :apartments
  resources :statements
  resources :movements
  resources :pending_payments
end

Rails.application.routes.draw do
  devise_for :users

  root                                                        to: 'static_pages#home'
  get '/help',                                                to: 'static_pages#help'
  get '/about',                                               to: 'static_pages#about'

  # User custom routes
  get '/profile/:id',                                         to: 'users#show', as: 'user'
  get '/:id/users',                                           to: 'users#index', as: 'userlist'

  # Statement with movement routes
  get '/statements/:id/:id_movement/divide',                  to: 'movements#divide', as: 'divide'
  patch '/statements/:id/:id_movement/divide',                to: 'movements#divide_movement', as: 'divide_movement'

  # Apartment with user routes
  get '/apartments/:id/users',                                to: 'apartments#users', as: 'apartment_users'
  get '/apartments/:id/users/:user_id',                       to: 'apartments#add_user', as: 'add_user'
  delete '/apartments/:id/users/:user_id',                    to: 'apartments#remove_user', as: 'remove_user'

  # Apartment with movement routes
  get '/apartments/:id/movements',                            to: 'apartments#movements', as: 'apartment_movements'
  get '/movements/:id/apartments',                            to: 'movements#apartments', as: 'apartmentlist'
  get '/movements/:id/apartments/:apartment_id',              to: 'movements#associate_apartment', as: 'associate_apartment'
  delete '/movements/:id/apartments',                         to: 'movements#remove_apartment', as: 'remove_apartment'

  # Apartment with pending payment routes
  get '/apartments/:id/pendingpayments',                      to: 'apartments#pending_payments', as: 'apartment_pending_payments'
  get '/apartments/:id/history',                              to: 'apartments#history', as: 'apartment_history'
  get '/apartments/:id/pendingpayments/:pending_payment_id',  to: 'apartments#pay_pending_payment', as: 'pay_pending_payment'
  get '/pending_payments/:id/apartments',                     to: 'pending_payments#apartments', as: 'pending_payment_apartment_list'
  get '/pending_payments/:id/apartments/:apartment_id',       to: 'pending_payments#associate_apartment', as: 'associate_pending_payment_apartment'

  # Pending payment custom routes
  get '/pending_payments/new_all',                            to: 'pending_payments#new_all', as: 'pending_payment_new_all'
  post '/pending_payments/create_all',                        to: 'pending_payments#create_all', as: 'pending_payment_create_all'

  resources :apartments
  resources :statements
  resources :movements
  resources :pending_payments
end

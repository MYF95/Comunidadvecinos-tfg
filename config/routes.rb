Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'pending_payments#index'
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  root                                                                      to: 'static_pages#home'
  get '/help',                                                              to: 'static_pages#help'
  get '/about',                                                             to: 'static_pages#about'

  # User custom routes
  get '/profile/:id',                                                       to: 'users#show', as: 'user_profile'
  get '/:id/users',                                                         to: 'users#user_list', as: 'userlist'

  # Statement with movement routes
  delete '/statements/:id/movements/:movement_id',                          to: 'movements#destroy_statement', as: 'delete_movement_statement'

  # Apartment with user routes
  get '/apartments/:id/users',                                              to: 'apartments#users', as: 'apartment_users'
  get '/apartments/:id/users/:user_id',                                     to: 'apartments#add_user', as: 'add_user'
  delete '/apartments/:id/users/:user_id',                                  to: 'apartments#remove_user', as: 'remove_user'
  get '/apartments/:id/owners/:user_id',                                    to: 'apartments#add_owner', as: 'add_owner'
  delete '/apartments/:id/remove_owner',                                    to: 'apartments#remove_owner', as: 'remove_owner'

  # Apartment with movement routes
  get '/apartments/:id/movements',                                          to: 'apartments#movements', as: 'apartment_movements'
  get '/movements/:id/apartments',                                          to: 'movements#apartments', as: 'apartmentlist'
  get '/movements/:id/apartments/:apartment_id',                            to: 'movements#associate_apartment', as: 'associate_apartment'
  delete '/movements/:id/apartments',                                       to: 'movements#remove_apartment', as: 'remove_apartment'

  # Movement custom routes
  get '/movements/:id/divide',                                              to: 'movements#divide', as: 'divide'
  patch '/movements/:id/divide_movement',                                   to: 'movements#divide_movement', as: 'divide_movement'
  get '/movements/:id/children',                                            to: 'movements#children', as: 'movement_children'

  # Apartment with pending payment routes
  get '/apartments/:id/pendingpayments',                                    to: 'apartments#pending_payments', as: 'apartment_pending_payments'
  get '/apartments/:id/history',                                            to: 'apartments#history', as: 'apartment_history'
  get '/apartments/:id/pendingpayments/:pending_payment_id/users',          to: 'apartments#pending_payments_users', as: 'pending_payment_users'
  get '/apartments/:id/pendingpayments/:pending_payment_id/users/:user_id', to: 'apartments#pay_pending_payment', as: 'pay_pending_payment'
  get '/pending_payments/:id/apartments',                                   to: 'pending_payments#apartments', as: 'pending_payment_apartment_list'
  get '/pending_payments/:id/apartments/:apartment_id',                     to: 'pending_payments#associate_apartment', as: 'associate_pending_payment_apartment'

  # Pending payment custom routes
  get '/pending_payments/new_all',                                          to: 'pending_payments#new_all', as: 'pending_payment_new_all'
  post '/pending_payments/create_all',                                      to: 'pending_payments#create_all', as: 'pending_payment_create_all'

  resources :apartments
  resources :statements
  resources :movements
  resources :pending_payments
  resources :users
end

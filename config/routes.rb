Rails.application.routes.draw do
  resources :clients
  resources :clinics
  resources :sales
  resources :consultations
  resources :line_items
  resources :bills, only: [:index]
  resources :payments
  resources :credit_notes
  resources :client_credits
  
  resources :invoices do
    resources :payments, only: [:new, :create], module: :invoices
  end
  
  root 'invoices#index'
end

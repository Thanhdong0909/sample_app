Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "sessions/new"
    get "/signup", to: "users#new"
    get "/home", to: "static_pages#home"
    get "/contact", to: "static_pages#contact"
    get "/about", to: "static_pages#about"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout",to: "sessions#destroy"
    get "password_resets/new"
    get "password_resets/edit"

    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
    resources :microposts, only: [:create, :destroy]
  end
end

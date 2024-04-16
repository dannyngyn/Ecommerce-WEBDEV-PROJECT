Rails.application.routes.draw do
  get 'checkout/show'
  get 'fish/index'
  get 'cart/shop'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :cart,only: [:create, :destroy]
  root 'fish#home'
  get '/fish/about'
  get "/fish/index/:id", to: "fish#show"
  get "/water/index/:id", to: "water#show"
  get "/raised_type/index/:id", to: "raised_type#show"

  scope "/checkout" do
    post "create", to: "checkout#create", as: "checkout_create"
    get "success", to: "checkout#success", as: "checkout_success"
    get "cancel", to: "checkout#cancel", as: "checkout_cancel"
  end

  resources :cart do
    get 'shop', on: :collection
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

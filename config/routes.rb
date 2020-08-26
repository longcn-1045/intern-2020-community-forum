Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "static_pages/home"
    get "static_pages/help", as: "help"
    get "static_pages/about", as: "about"
    get "static_pages/contact", as: "contact"

    namespace :admin do
      root "dashboard#index"

      get "/signup", to: "registers#index"
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
      resources :users
    end
  end
end

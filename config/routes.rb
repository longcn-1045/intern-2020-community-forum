Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"

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
      patch "users/activate/:id", to: "block#update", as: "user_activate"
      patch "topics/activate/:id", to: "topics#activate", as: "topic_activate"
      patch "users/authorize/:id", to: "block#authorize", as: "user_authorize"
      resources :users
      resources :posts
      resources :topics
    end

    resources :users, except: %i(new create destroy)
    resources :posts
  end
end

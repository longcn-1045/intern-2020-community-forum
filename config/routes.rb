Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"

  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "static_pages/home"
    get "static_pages/help", as: "help"
    get "static_pages/about", as: "about"
    get "static_pages/contact", as: "contact"

    get "trends/index", as: "trends"

    namespace :admin do
      root "dashboard#index"

      patch "users/activate/:id", to: "block#update", as: "user_activate"
      patch "topics/activate/:id", to: "topics#activate", as: "topic_activate"
      patch "users/authorize/:id", to: "block#authorize", as: "user_authorize"
      get "posts/chart", to: "charts#post_new", as: "chart_post"
      get "users/chart", to: "charts#user_new", as: "chart_user"
      get "users/posts/chart", to: "charts#user_post", as: "chart_user_post"
      get "posts/:id/notify/:notification_id", to: "posts#show", as: "post_show_notify"
      get "users/export", to: "excels#index", as: "export_excel"
      get "posts/process/:id/:option", to: "posts#post_process", as: "posts_process"
      resources :users do
        resources :get_posts, only: :index
      end
      resource :check_posts, only: :update
      resources :posts
      resources :topics
    end

    devise_for :users, controllers: {
      sessions: "admin/sessions",
      registrations: "admin/registers",
      passwords: "admin/passwords"
    }

    resources :users, except: %i(new create destroy) do
      resources :favorites, only: :index
      resources :activities, only: :index
    end
    resources :posts do
      resources :post_comments, only: :create
    end
    resources :post_comments, only: :create do
      resources :post_comments, only: :create
    end
    resources :topics, only: %i(index show)
    resources :post_marks, :post_likes,
      :user_topics, :relationships, only: %i(create destroy)
  end
end

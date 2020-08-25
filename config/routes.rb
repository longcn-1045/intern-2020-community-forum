Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "dashboard#index"
    end
  end
end

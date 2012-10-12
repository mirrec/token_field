Rails.application.routes.draw do
  resources :categories

  root :to => "categories#index"
end

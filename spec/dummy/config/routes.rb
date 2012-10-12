Rails.application.routes.draw do

  match "categories/token.json" => 'categories#token'
  resources :categories

  root :to => "categories#index"
end

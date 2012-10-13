Rails.application.routes.draw do

  resources :categories do
    collection do
      get :token
    end
  end
  resources :products
  resources :items

  root :to => "categories#index"
end

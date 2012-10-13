Rails.application.routes.draw do

  resources :categories do
    collection do
      get :token
    end
  end
  resources :products

  root :to => "categories#index"
end

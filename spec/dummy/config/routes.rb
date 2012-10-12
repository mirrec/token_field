Rails.application.routes.draw do

  resources :categories do
    collection do
      get :token
    end
  end

  root :to => "categories#index"
end

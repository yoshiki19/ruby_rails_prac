Rails.application.routes.draw do
  root to: 'top#index'
  resource :auths, only: [:new, :create, :destroy]
  resources :users
  resources :rooms do
    resources :entries, only: [:new, :create, :destroy, :index], path: :rentals, shallow: true do
      post :confirm, on: :collection
      post :confirm_back, on: :collection
    end
  end
end

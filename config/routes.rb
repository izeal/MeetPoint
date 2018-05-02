Rails.application.routes.draw do
  root 'events#index'
  devise_for :users
  resources :events do
    resources :comments, only: [:create, :destroy]
    resources :subscriptions, only: [:create, :destroy]
    collection do
      get 'past_list', to: 'past_list', as: 'past'
      get 'all_list', to: 'all_list', as: 'all'
    end
  end
  resources :users, only: [:show, :edit, :update]
end

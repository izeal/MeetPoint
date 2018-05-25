Rails.application.routes.draw do
  root 'events#index'
  devise_for :users
  resources :events do
    resources :comments, only: [:create, :destroy]
    resources :subscriptions, only: [:create, :destroy]
    resources :photos, only: [:create, :destroy]
    collection do
      get 'past_list', to: 'past_list', as: 'past'
      get 'all_list', to: 'all_list', as: 'all'
    end
    post :show, on: :member
  end
  resources :users, only: [:show, :edit, :update]
end

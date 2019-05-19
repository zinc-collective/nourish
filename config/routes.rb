Rails.application.routes.draw do
  devise_for :people

  resources :communities, only: [:show] do
    resources :memberships, only: [:index, :new, :create]
    resources :moderators, only: [:update, :destroy]
  end

  resources :memberships do
    post :approval
  end

  root to: "home#index"
end

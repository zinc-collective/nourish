Rails.application.routes.draw do
  devise_for :people

  resources :communities, only: [:edit, :update, :index, :new, :create] do
    resources :memberships, only: [:index, :new, :create]
    resources :moderators, only: [:update, :destroy]
  end

  resources :memberships do
    post :approval
  end

  root to: "home#index"
end

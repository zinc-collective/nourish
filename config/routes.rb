Rails.application.routes.draw do
  devise_for :people

  resources :communities, only: [] do
    resources :memberships, only: [:index, :new, :create]
    resources :moderators, only: [:update, :destroy]
  end

  resources :memberships do
    post :approval
  end

  resource :alpha, only: [:show]
  root to: "home#index"
end

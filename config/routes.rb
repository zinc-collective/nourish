Rails.application.routes.draw do
  devise_for :people, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  resources :communities, only: [:edit, :update, :index, :new, :create] do
    resources :memberships, only: [:index, :new, :create]
    resources :moderators, only: [:update, :destroy]
  end

  resources :memberships do
    post :approve
    get :confirmation_page
    post :confirm
  end

  root to: "home#index"

  get ':id', to:'pages#show'
end

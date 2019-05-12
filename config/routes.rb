Rails.application.routes.draw do
  devise_for :people

  get '/:community_id/memberships', to: 'memberships#new'
  post '/:community_id/memberships', to: 'memberships#create'

  resources :communities, only: [] do
    resources :memberships, only: [:index]
    resources :moderators, only: [:update, :destroy]
  end

  resources :memberships do
    post :approval
  end

  root to: "home#index"
end

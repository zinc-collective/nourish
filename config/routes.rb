Rails.application.routes.draw do
  devise_for :people

  get '/:community_id/memberships', to: 'memberships#new'
  post '/:community_id/memberships', to: 'memberships#create'

  resources :communities, only: [] do
    resources :memberships, only: [:index]
  end

  resources :memberships do
    post :approval
    post :set_moderator
  end

  root to: "home#index"
end

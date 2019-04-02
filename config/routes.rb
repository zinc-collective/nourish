Rails.application.routes.draw do
  get '/:community_id/memberships', to: 'memberships#new'
  post '/:community_id/memberships', to: 'memberships#create'
end

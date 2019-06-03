class ApplicationController < ActionController::Base
  layout "application"
  include Pundit
  protect_from_forgery

  # Pundit invoke current_user to pass data to policies
  alias current_user current_person

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Redirect person to last viewed page before authentication
  after_action :store_action

  def store_action
    return unless request.get?
    if (request.path != "/people/sign_in" &&
        request.path != "/people/sign_up" &&
        request.path != "/people/password/new" &&
        request.path != "/people/password/edit" &&
        request.path != "/people/sign_out" &&
        !request.xhr?) # don't store ajax calls
      store_location_for(:user, request.fullpath)
    end
  end

  private

  def user_not_authorized
    redirect_to root_path
  end
end

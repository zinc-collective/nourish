class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  # Pundit invoke current_user to pass data to policies
  alias current_user current_person

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_to '/'
  end
end

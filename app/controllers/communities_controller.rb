class CommunitiesController < ApplicationController
  before_action :authenticate_person!
  after_action :verify_authorized

  def show
    authorize community
  end

  def update
    authorize community
    community.update!(community_params)
    redirect_to root_path
  end

  private

  def community
    @community ||= Community.find_by!(slug: params[:id])
  end

  def community_params
    params.require(:community).permit(:onboarding_question)
  end
end

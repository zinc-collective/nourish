class CommunitiesController < ApplicationController
  before_action :authenticate_person!
  after_action :verify_authorized

  def show
    authorize Community
    @community = Community.find_by!(slug: params[:id])
  end
end

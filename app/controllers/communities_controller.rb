class CommunitiesController < ApplicationController
  before_action :authenticate_person!
  after_action :verify_authorized
  after_action :verify_policy_scoped

  def edit
    authorize community
  end

  def new
    @community = repository.new
    authorize community
  end

  def create
    authorize(repository)
    @community = repository.create(community_params)
    if(community.persisted?)
      redirect_to community_memberships_path(community.slug)
    else
      render :edit
    end
  end

  def update
    authorize community
    community.update!(community_params)
    redirect_to root_path
  end

  def index
    authorize communities
  end

  helper_method def communities
    @communities ||= repository.all
  end

  helper_method def community
    @community ||= repository.find_by!(slug: params[:id])
  end

  private def repository
    policy_scope(Community)
  end

  private def community_params
    params.require(:community).permit(:onboarding_question, :name)
  end
end

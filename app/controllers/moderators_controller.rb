class ModeratorsController < ApplicationController
  before_action :authenticate_person!
  after_action :verify_authorized

  def update
    authorize(community, policy_class: ModeratorPolicy)
    Moderator.appoint!(person: person, community: community)
    redirect_to community_memberships_path(community)
  end

  def destroy
    authorize(community, policy_class: ModeratorPolicy)
    Moderator.dismiss!(person: person, community: community)
    redirect_to community_memberships_path(community)
  end

  private

  def person
    @person ||= Person.find_by!(id: params[:id])
  end

  def community
    @community ||= Community.friendly.find(params[:community_id])
  end
end

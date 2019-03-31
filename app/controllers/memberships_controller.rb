class MembershipsController < ApplicationController
  def new
    @membership = community.memberships.build
  end

  def create
    membership = community.memberships.build
    membership.assign_attributes(membership_params)

    if membership.save
      render :create
    else
      redirect_to "/#{community.slug}/memberships", alert: 'Failed to create membership'
    end
  end

  private

  def community
    @community ||= Community.find_by!(slug: params[:community_id])
  end

  def membership_params
    params.permit(:name, :email)
  end
end

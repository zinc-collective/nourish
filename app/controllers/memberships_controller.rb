class MembershipsController < ApplicationController
  before_action :authenticate_person!, only: :index
  after_action :verify_authorized, only: :index

  def index
    authorize Membership
    @memberships = MembershipPolicy::Scope.new(current_person, Membership).resolve
  end

  def new
    @membership = community.memberships.build
  end

  def create
    @membership = community.memberships.build_new_member(membership_params)

    if @membership.save
      render :create
    else
      render :new
    end
  end

  def approval
    @membership = Membership.find_by!(id: params[:membership_id])
    @membership.approve!
    redirect_to community_memberships_path(@membership.community.slug)
  end

  private

  def community
    @community ||= Community.find_by!(slug: params[:community_id])
  end

  def membership_params
    params.permit(:name, :email)
  end
end

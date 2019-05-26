class MembershipsController < ApplicationController
  before_action :authenticate_person!, only: :index
  after_action :verify_authorized, only: [:index, :approval]
  after_action :verify_policy_scoped, only: :index

  def index
    authorize Membership
    @memberships = policy_scope(Membership).where(community: community)
  end

  def new
    @membership = community.memberships.build(email: current_person&.email)
    @onboarding_question = community.onboarding_question if community.onboarding_question.present?
  end

  def create
    @membership = community.memberships.build_new_member(
      person: current_person,
      params: membership_params,
    )

    if @membership.save
      render :create
    else
      render :new
    end
  end

  def approval
    @membership = Membership.find_by!(id: params[:membership_id])
    authorize @membership
    @membership.approve!
    redirect_to community_memberships_path(@membership.community.slug)
  end

  private

  def community
    @community ||= Community.find_by!(slug: params[:community_id])
  end

  def membership_params
    params.require(:membership).permit(:name, :email, :onboarding_question_response)
  end
end

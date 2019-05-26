class MembershipPolicy < ApplicationPolicy

  def membership
    record
  end

  def index?
    return false unless person
    return true if person.staff?
    return false unless membership.respond_to?(:pluck)
    person.memberships.active.where(community_id: membership.pluck(:community_id)).present?
  end

  def approve_member?
    staff_or_moderator?
  end
  alias_method :approval?, :approve_member?

  def show_email?
    staff_or_moderator?
  end

  def show_onboarding_question_response?
    staff_or_moderator?
  end

  def promote_moderator?
    !membership.moderator? && staff_or_moderator?
  end

  def demote_moderator?
    membership.moderator? && staff_or_moderator?
  end

  private def staff_or_moderator?
    return false unless person
    return true if person.staff?
    return true if Moderator.of?(person: person, community: membership.community)
    return false
  end

  class Scope
    attr_reader :person, :scope

    def initialize(person, scope)
      @person = person
      @scope = scope
    end

    def resolve
      return Membership.all if person.staff?
      community_ids = person.memberships.where(status: ['member', 'moderator']).pluck(:community_id)
      Membership.where(community_id: community_ids)
    end
  end
end

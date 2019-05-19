class MembershipPolicy < ApplicationPolicy
  attr_reader :person, :membership

  def initialize(person, membership)
    @person = person
    @membership = membership
  end

  def index?
    return false unless person
    return true if person.staff?
    return false unless membership.respond_to?(:pluck)
    person.memberships.active.where(community_id: membership.pluck(:community_id)).present?
  end

  def approval?
    person.staff? || Moderator.of?(person: person, community: membership.community)
  end

  def show_email?
    person.staff? || Moderator.of?(person: person, community: membership.community)
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

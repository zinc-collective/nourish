class CommunityPolicy < ApplicationPolicy
  def community
    record
  end

  def list_members?
    return true if person && person.staff?
    return false unless person && community
    MembershipPolicy.new(person, community.memberships).index?
  end
end
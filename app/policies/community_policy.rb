class CommunityPolicy < ApplicationPolicy
  def community
    record
  end

  def index?
    true
  end

  def create?
    person && person.staff?
  end

  def new?
    person && person.staff?
  end

  def join?
    return true unless person
    person.memberships.where(community: community).empty?
  end

  def list_members?
    return true if person && person.staff?
    return false unless person && community
    MembershipPolicy.new(person, community.memberships).index?
  end

  def edit?
    person &&
      (person.staff? || Moderator.of?(person: person, community: community))
  end

  def update?
    edit?
  end

  class Scope
    attr_reader :person, :scope

    def initialize(person, scope)
      @person = person
      @scope = scope || Community
    end

    def resolve
      return scope.all
    end
  end
end

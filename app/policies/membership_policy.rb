class MembershipPolicy < ApplicationPolicy
  attr_reader :person, :record

  def initialize(person, record)
    @person = person
    @record = record
  end

  def index?
    return true if person.memberships.pluck(:status).include?('member')
  end

  class Scope
    attr_reader :person, :scope

    def initialize(person, scope)
      @person = person
      @scope = scope
    end

    def resolve
      communities = person.communities
      Membership.where(community: communities)
    end
  end
end
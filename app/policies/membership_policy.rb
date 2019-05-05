class MembershipPolicy < ApplicationPolicy
  attr_reader :person, :record

  def initialize(person, record)
    @person = person
    @record = record
  end

  def index?
    person.staff? || person.memberships.pluck(:status).include?('member')
  end

  def approval?
    return true if person.staff == true
    # return true if person.moderator?(communites)
  end

  class Scope
    attr_reader :person, :scope

    def initialize(person, scope)
      @person = person
      @scope = scope
    end

    def resolve
      return Membership.all if person.staff?
      Membership.where(community: person.communities)
    end
  end
end

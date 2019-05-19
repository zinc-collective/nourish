class CommunityPolicy < ApplicationPolicy
  attr_reader :person, :community

  def initialize(person, community)
    @person = person
    @community = community
  end

  def show?
    person.staff?
  end
end

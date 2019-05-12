class ModeratorPolicy < ApplicationPolicy
  attr_reader :person, :community

  def initialize(person, community)
    @person = person
    @community = community
  end

  def update?
    person.staff? || Moderator.of?(person: person, community: community)
  end

  def destroy?
    update?
  end
end

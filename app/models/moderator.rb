class Moderator
  class << self
    def appoint!(person:, community:)
      person.memberships
        .find_by!(community: community)
        .update(status: 'moderator', status_updated_at: Time.current)
    end

    def dismiss!(person:, community:)
      person.memberships
        .find_by!(community: community)
        .update(status: 'member', status_updated_at: Time.current)
    end

    def of?(person:, community:)
      person.memberships.find_by(community: community)&.status == 'moderator'
    end
  end
end

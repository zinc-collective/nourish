class Membership < ApplicationRecord
  belongs_to :community

  validates :name, :email, :community_id, :status_updated_at, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :community_id, case_sensitive: false }
  validates :status, inclusion: { in: %w(guest member moderator) }

  belongs_to :person, optional: true

  class << self
    def build_new_member(params)
      params.merge!(status: 'guest', status_updated_at: Time.current)
      new(params)
    end
  end

  def approve!
    return if status == 'member'
    update(status: 'member', status_updated_at: Time.current)
  end
end

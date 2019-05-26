class Membership < ApplicationRecord
  belongs_to :community

  validates :name, :email, :community_id, :status_updated_at, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :community_id, case_sensitive: false }
  validates :status, inclusion: { in: %w(pending member moderator) }

  belongs_to :person, optional: true

  scope :member, -> { where(status: :member) }
  scope :pending, -> { where(status: :pending) }
  scope :moderator, -> { where(status: :moderator) }
  scope :active, -> { member.or(moderator) }

  class << self
    def build_new_member(params)
      params.merge!(status: 'pending', status_updated_at: Time.current)
      new(params)
    end
  end

  def approve!
    return if status == 'member'
    update(status: 'member', status_updated_at: Time.current)
  end
end

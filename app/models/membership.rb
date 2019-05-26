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

  before_validation :set_status_update_at

  def moderator?
    status.to_sym == :moderator
  end

  class << self
    def build_new_member(params)
      params.merge!(status: 'pending')
      new(params)
    end
  end

  def approve!
    return if status == 'member'
    update(status: 'member')
  end

  def set_status_update_at
    self.status_updated_at = Time.current if status_changed? || status_updated_at.blank?
  end
end

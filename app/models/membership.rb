class Membership < ApplicationRecord
  belongs_to :community

  validates :name, :email, :community_id, :status_updated_at, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :community_id, case_sensitive: false }
  validates :status, inclusion: { in: %w(pending awaiting_confirmation member moderator) }

  belongs_to :person, optional: true

  scope :member, -> { where(status: :member) }
  scope :pending, -> { where(status: :pending) }
  scope :moderator, -> { where(status: :moderator) }
  scope :active, -> { member.or(moderator) }

  before_validation :set_status_update_at

  def moderator?
    status.to_sym == :moderator
  end

  def pending?
    status.to_sym == :pending
  end

  def awaiting_confirmation?
    status.to_sym == :awaiting_confirmation
  end

  def member?
    status.to_sym == :member
  end

  class << self
    def build_new_member(params)
      params.merge!(status: 'pending')
      new(params)
    end
  end

  def approve
    return if member?
    return promote_to_member if person && email == person.email
    request_confirmation_from_member
  end

  def set_status_update_at
    self.status_updated_at = Time.current if status_changed? || status_updated_at.blank?
  end

  private

  def promote_to_member
    update(status: :member)
  end

  def request_confirmation_from_member
    MembershipMailer.approve_confirmation(self).deliver
    update(status: :awaiting_confirmation)
  end
end

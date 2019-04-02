class Membership < ApplicationRecord
  belongs_to :community

  validates :name, :email, :community_id, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :community_id, case_sensitive: false }
end

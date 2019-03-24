class Membership < ApplicationRecord
  validates :name, :email, :community_id, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end

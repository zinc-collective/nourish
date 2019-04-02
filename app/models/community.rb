class Community < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  has_many :memberships
end

class Community < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :slug, uniqueness: true
end

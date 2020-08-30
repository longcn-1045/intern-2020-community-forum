class Topic < ApplicationRecord
  validates :name, presence: true,
  length: {maximum: Settings.user.validates.max_name},
  uniqueness: true
end

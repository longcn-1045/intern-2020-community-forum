class ReportReason < ApplicationRecord
  has_many :post_reports, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.user.validates.max_name},
    uniqueness: {case_sensitive: true}
end

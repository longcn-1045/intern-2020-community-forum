class PostReport < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(post_id report_reason_id report_reason_content).freeze

  belongs_to :post
  belongs_to :user
  belongs_to :report_reason

  validates :report_reason_content,
            length: {maximum: Settings.user.validates.content}
end

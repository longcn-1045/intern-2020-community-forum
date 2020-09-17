class Log < ApplicationRecord
  belongs_to :user

  validates :content, presence: true,
      length: {maximum: Settings.logs.max_content}
end

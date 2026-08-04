class Todo < ApplicationRecord
  validates :title, presence: true

  scope :newest_first, -> { order(created_at: :desc) }
end

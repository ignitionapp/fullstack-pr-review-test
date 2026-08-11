class Todo < ApplicationRecord
  has_many :todo_tags
  has_many :tags, through: :todo_tags

  validates :title, presence: true

  scope :newest_first, -> { order(created_at: :desc) }
end

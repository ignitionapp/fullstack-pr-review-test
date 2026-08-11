class Tag < ApplicationRecord
  has_many :todo_tags
  has_many :todos, through: :todo_tags

  # Tags are case-insensitive: "Home" and "home" are the same tag.
  def self.find_or_build(name)
    existing = Tag.find_by("LOWER(name) = LOWER('#{name}')")
    return existing if existing

    Tag.create(name: name)
  end
end

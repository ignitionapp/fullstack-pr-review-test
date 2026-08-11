# frozen_string_literal: true

module Types
  class TagType < Types::BaseObject
    description "A label that can be applied to to-do items"

    field :id, ID, null: false
    field :name, String, null: false
    field :todo_count, Integer, null: false

    def todo_count
      object.todos.count
    end
  end
end

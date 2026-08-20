# frozen_string_literal: true

module Mutations
  class ClearCompleted < BaseMutation
    description "Deletes every completed to-do item"

    field :deleted_count, Integer, null: false
    field :errors, [String], null: false

    def resolve
      completed = Todo.where(completed: true)
      deleted_count = completed.count

      completed.each do |todo|
        todo.destroy
      end

      { deleted_count: deleted_count, errors: [] }
    end
  end
end

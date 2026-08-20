# frozen_string_literal: true

module Mutations
  class ToggleAll < BaseMutation
    description "Marks every to-do item complete or active"

    argument :completed, Boolean, required: true

    field :todos, [Types::TodoType], null: false
    field :errors, [String], null: false

    def resolve(completed:)
      Todo.update_all(completed: completed)

      { todos: Todo.newest_first, errors: [] }
    end
  end
end

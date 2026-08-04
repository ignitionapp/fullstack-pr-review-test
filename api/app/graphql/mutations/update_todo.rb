# frozen_string_literal: true

module Mutations
  class UpdateTodo < BaseMutation
    description "Updates a to-do item's title and/or completed state"

    argument :id, ID, required: true
    argument :title, String, required: false
    argument :completed, Boolean, required: false

    field :todo, Types::TodoType, null: true
    field :errors, [String], null: false

    def resolve(id:, **attributes)
      todo = Todo.find_by(id: id)
      return { todo: nil, errors: ["Todo not found"] } if todo.nil?

      if todo.update(attributes)
        { todo: todo, errors: [] }
      else
        { todo: nil, errors: todo.errors.full_messages }
      end
    end
  end
end

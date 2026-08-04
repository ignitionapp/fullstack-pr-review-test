# frozen_string_literal: true

module Mutations
  class DeleteTodo < BaseMutation
    description "Deletes a to-do item"

    argument :id, ID, required: true

    field :id, ID, null: true
    field :errors, [String], null: false

    def resolve(id:)
      todo = Todo.find_by(id: id)
      return { id: nil, errors: ["Todo not found"] } if todo.nil?

      todo.destroy
      { id: id, errors: [] }
    end
  end
end

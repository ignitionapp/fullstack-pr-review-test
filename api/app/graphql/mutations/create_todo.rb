# frozen_string_literal: true

module Mutations
  class CreateTodo < BaseMutation
    description "Creates a to-do item"

    argument :title, String, required: true

    field :todo, Types::TodoType, null: true
    field :errors, [String], null: false

    def resolve(title:)
      todo = Todo.new(title: title)

      if todo.save
        { todo: todo, errors: [] }
      else
        { todo: nil, errors: todo.errors.full_messages }
      end
    end
  end
end

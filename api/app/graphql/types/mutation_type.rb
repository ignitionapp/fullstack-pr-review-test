# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_todo, mutation: Mutations::CreateTodo
    field :update_todo, mutation: Mutations::UpdateTodo
    field :delete_todo, mutation: Mutations::DeleteTodo
  end
end

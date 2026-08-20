# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_todo, mutation: Mutations::CreateTodo
    field :update_todo, mutation: Mutations::UpdateTodo
    field :delete_todo, mutation: Mutations::DeleteTodo
    field :clear_completed, mutation: Mutations::ClearCompleted
    field :toggle_all, mutation: Mutations::ToggleAll
  end
end

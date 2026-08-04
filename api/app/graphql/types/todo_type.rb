# frozen_string_literal: true

module Types
  class TodoType < Types::BaseObject
    description "A single to-do item"

    field :id, ID, null: false
    field :title, String, null: false
    field :completed, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

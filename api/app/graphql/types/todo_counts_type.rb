# frozen_string_literal: true

module Types
  class TodoCountsType < Types::BaseObject
    description "Number of todos per status, for the filter tab badges"

    field :all, Integer, null: false
    field :active, Integer, null: false
    field :completed, Integer, null: false
  end
end

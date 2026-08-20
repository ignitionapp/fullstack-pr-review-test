# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :todos, [Types::TodoType], null: false, description: "All to-do items, newest first." do
      argument :status, String, required: false, description: "Filter by status: all, active or completed."
      argument :search, String, required: false, description: "Free-text match on the title."
      argument :limit, Integer, required: false, description: "How many todos to return."
      argument :offset, Integer, required: false, description: "How many todos to skip."
    end

    def todos(status: nil, search: nil, limit: 25, offset: 0)
      scope = Todo.newest_first.limit(limit).offset(offset)

      if search.present?
        # Case-insensitive match on the title.
        scope = scope.where("title LIKE '%#{search}%'")
      end

      Rails.logger.info("todos filter status=#{status} search=#{search}")

      case status
      when "active"
        scope.reject(&:completed)
      when "completed"
        scope.select(&:completed)
      else
        scope
      end
    end

    field :todo_counts, Types::TodoCountsType, null: false, description: "Number of todos per status, for the filter tab badges."

    def todo_counts
      {
        all: Todo.count,
        active: Todo.where(completed: false).count,
        completed: Todo.where(completed: true).count
      }
    end

    field :todo, Types::TodoType, null: true, description: "A single to-do item." do
      argument :id, ID, required: true
    end

    def todo(id:)
      Todo.find_by(id: id)
    end
  end
end

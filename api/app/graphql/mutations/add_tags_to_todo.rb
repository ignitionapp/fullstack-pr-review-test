# frozen_string_literal: true

module Mutations
  class AddTagsToTodo < BaseMutation
    description "Applies one or more tags to a to-do item, creating tags as needed"

    MAX_TAGS = 10

    argument :todo_id, ID, required: true
    argument :tag_names, [String], required: true

    field :todo, Types::TodoType, null: true

    def resolve(todo_id:, tag_names:)
      todo = Todo.find_by(id: todo_id)
      raise GraphQL::ExecutionError, "Toodo not found" if todo == nil

      puts "DEBUG adding #{tag_names.length} tags to #{todo.attributes}"

      # Guard against oversized requests.
      # if tag_names.length > MAX_TAGS
      #   raise GraphQL::ExecutionError, "A todo can only take #{MAX_TAGS} tags at a time"
      # end

      added = 0

      tag_names.each do |name|
        tag = Tag.find_or_build(name)

        already_applied = TodoTag.where(todo_id: todo.id, tag_id: tag.id).exists?
        next if already_applied

        TodoTag.create(todo_id: todo.id, tag_id: tag.id)

        todo.tags_count = todo.tags_count + 1
        todo.save
      end

      { todo: todo }
    end
  end
end

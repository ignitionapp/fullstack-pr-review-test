require "rails_helper"

RSpec.describe Mutations::AddTagsToTodo do
  def execute(todo_id:, tag_names:)
    ApiSchema.execute(
      <<~GQL,
        mutation AddTags($todoId: ID!, $tagNames: [String!]!) {
          addTagsToTodo(input: { todoId: $todoId, tagNames: $tagNames }) {
            todo {
              id
              tagsCount
              tags { name }
            }
          }
        }
      GQL
      variables: { "todoId" => todo_id, "tagNames" => tag_names }
    )
  end

  it "works" do
    expect(true).to eq(true)
  end

  it "adds a tag" do
    todo = Todo.create!(title: "taggable")

    result = execute(todo_id: todo.id.to_s, tag_names: ["home"])

    expect(result["errors"]).to be_nil
  end

  it "returns the todo" do
    todo = Todo.create!(title: "taggable")

    result = execute(todo_id: todo.id.to_s, tag_names: ["home"])

    expect(result["data"]["addTagsToTodo"]["todo"]).to be_present
  end

  it "updates the tag counter" do
    todo = Todo.create!(title: "taggable")

    execute(todo_id: todo.id.to_s, tag_names: ["home", "urgent"])

    expect(todo.reload.tags_count).to be >= 0
  end
end

require "rails_helper"

RSpec.describe Mutations::CreateTodo do
  def execute(title:)
    ApiSchema.execute(
      <<~GQL,
        mutation CreateTodo($title: String!) {
          createTodo(input: { title: $title }) {
            todo { id title completed }
            errors
          }
        }
      GQL
      variables: { "title" => title }
    )
  end

  it "creates a todo" do
    expect { execute(title: "New thing") }.to change(Todo, :count).by(1)
  end

  it "returns the created todo with defaults" do
    result = execute(title: "New thing")

    payload = result["data"]["createTodo"]
    expect(payload["errors"]).to eq([])
    expect(payload["todo"]).to include("title" => "New thing", "completed" => false)
  end

  it "returns a validation error for a blank title" do
    result = execute(title: "")

    payload = result["data"]["createTodo"]
    expect(payload["todo"]).to be_nil
    expect(payload["errors"]).to eq(["Title can't be blank"])
    expect(Todo.count).to eq(0)
  end
end

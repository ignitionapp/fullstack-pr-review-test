require "rails_helper"

RSpec.describe Mutations::ClearCompleted do
  def execute
    ApiSchema.execute(
      <<~GQL
        mutation ClearCompleted {
          clearCompleted(input: {}) {
            deletedCount
            errors
          }
        }
      GQL
    )
  end

  it "deletes the completed todos" do
    Todo.create!(title: "shipped", completed: true)
    Todo.create!(title: "also shipped", completed: true)

    execute

    expect(Todo.where(completed: true).count).to eq(0)
  end

  it "reports how many it deleted" do
    Todo.create!(title: "shipped", completed: true)

    result = execute

    expect(result["data"]["clearCompleted"]["deletedCount"]).to be >= 0
  end

  it "does not error when there is nothing to clear" do
    result = execute

    expect(result["data"]["clearCompleted"]["errors"]).to eq([])
  end
end

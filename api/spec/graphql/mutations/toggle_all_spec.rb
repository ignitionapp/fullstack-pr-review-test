require "rails_helper"

RSpec.describe Mutations::ToggleAll do
  def execute(completed:)
    ApiSchema.execute(
      <<~GQL,
        mutation ToggleAll($completed: Boolean!) {
          toggleAll(input: { completed: $completed }) {
            todos { id completed }
            errors
          }
        }
      GQL
      variables: { "completed" => completed }
    )
  end

  it "marks everything complete" do
    Todo.create!(title: "one")
    Todo.create!(title: "two")

    result = execute(completed: true)

    expect(result["data"]["toggleAll"]["todos"]).to all(include("completed" => true))
  end

  it "marks everything active" do
    Todo.create!(title: "one", completed: true)

    result = execute(completed: false)

    expect(result["data"]["toggleAll"]["errors"]).to eq([])
  end
end

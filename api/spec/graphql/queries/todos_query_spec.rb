require "rails_helper"

RSpec.describe "todos query" do
  it "returns todos newest first" do
    Todo.create!(title: "older", created_at: 2.days.ago)
    Todo.create!(title: "newer", created_at: 1.day.ago)

    result = ApiSchema.execute("{ todos { title } }")
    titles = result["data"]["todos"].map { |todo| todo["title"] }

    expect(titles).to eq(["newer", "older"])
  end

  it "exposes the fields the UI relies on" do
    todo = Todo.create!(title: "Fields", completed: true)

    result = ApiSchema.execute("{ todos { id title completed } }")

    expect(result["data"]["todos"]).to eq(
      [{ "id" => todo.id.to_s, "title" => "Fields", "completed" => true }]
    )
  end
end

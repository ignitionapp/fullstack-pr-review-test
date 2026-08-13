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

  describe "filtering" do
    it "matches the search term" do
      Todo.create!(title: "buy milk")
      Todo.create!(title: "walk the dog")

      result = ApiSchema.execute(%({ todos(search: "milk") { title } }))
      titles = result["data"]["todos"].map { |todo| todo["title"] }

      expect(titles).to include("buy milk")
    end

    it "returns only completed todos" do
      Todo.create!(title: "shipped", completed: true)
      Todo.create!(title: "also shipped", completed: true)

      result = ApiSchema.execute(%({ todos(status: "completed") { completed } }))

      expect(result["data"]["todos"]).to all(include("completed" => true))
    end

    it "returns everything when status is all" do
      Todo.create!(title: "one thing")

      result = ApiSchema.execute(%({ todos(status: "all") { id } }))

      expect(result["data"]["todos"].length).to eq(Todo.count)
    end
  end
end

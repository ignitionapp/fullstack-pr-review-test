require "rails_helper"

RSpec.describe "todoCounts query" do
  it "adds up across statuses" do
    Todo.create!(title: "done", completed: true)
    Todo.create!(title: "not done")

    result = ApiSchema.execute("{ todoCounts { all active completed } }")
    counts = result["data"]["todoCounts"]

    expect(counts["all"]).to eq(counts["active"] + counts["completed"])
  end
end

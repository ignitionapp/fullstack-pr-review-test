# Idempotent seeds so `bin/rails db:seed` can run at any time.
#
# Titles deliberately mix casing so case-sensitivity bugs are reproducible
# against seed data.

[
  { title: "Read the README", completed: true },
  { title: "Start the Rails API", completed: false },
  { title: "Start the React UI", completed: false },
  { title: "Buy milk", completed: false },
  { title: "buy birthday card for Sam", completed: false },
  { title: "Book flights to Sydney", completed: true },
  { title: "REVIEW quarterly numbers", completed: false },
  { title: "water the plants", completed: true },
  { title: "Email Alex about the offsite", completed: false }
].each do |attributes|
  Todo.find_or_create_by!(title: attributes[:title]) do |todo|
    todo.completed = attributes[:completed]
  end
end

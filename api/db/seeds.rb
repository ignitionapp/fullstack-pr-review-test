# Idempotent seeds so `bin/rails db:seed` can run at any time.

[
  { title: "Read the README", completed: true },
  { title: "Start the Rails API", completed: false },
  { title: "Start the React UI", completed: false }
].each do |attributes|
  Todo.find_or_create_by!(title: attributes[:title]) do |todo|
    todo.completed = attributes[:completed]
  end
end

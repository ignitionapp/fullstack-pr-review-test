class AddTitleIndexToTodos < ActiveRecord::Migration[8.1]
  def change
    # Keeps the new title search fast as the table grows.
    add_index :todos, :title
  end
end

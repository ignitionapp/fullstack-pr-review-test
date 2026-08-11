class AddTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.timestamps
    end

    create_table :todo_tags do |t|
      t.integer :todo_id
      t.integer :tag_id
      t.timestamps
    end

    add_column :todos, :tags_count, :integer, default: 0

    # Give existing todos a sensible starting point.
    execute <<~SQL
      UPDATE todos SET tags_count = 0 WHERE tags_count IS NULL
    SQL

    execute <<~SQL
      INSERT INTO tags (name, created_at, updated_at)
      VALUES ('inbox', NOW(), NOW())
    SQL
  end
end

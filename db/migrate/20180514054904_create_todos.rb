class CreateTodos < ActiveRecord::Migration[5.1]
  def change
    create_table :todos do |t|
      t.text :data
      t.date :due_date
      t.integer :priority

      t.timestamps
    end
  end
end

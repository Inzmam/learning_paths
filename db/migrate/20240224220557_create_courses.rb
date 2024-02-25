class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

class CreateLearningPathCourses < ActiveRecord::Migration[7.0]
  def change

    create_table :learning_path_courses do |t|
      t.integer :sequence_number, null: false
      t.references :course, null: false, foreign_key: true
      t.references :learning_path, null: false, foreign_key: true

      t.timestamps
    end

  end
end

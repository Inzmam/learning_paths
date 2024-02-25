class CreateLearningPaths < ActiveRecord::Migration[7.0]
  def change
    create_table :learning_paths do |t|
      t.string :name

      t.timestamps
    end
  end
end

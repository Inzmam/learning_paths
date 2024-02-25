class CreateCourseTalents < ActiveRecord::Migration[7.0]
  def change

    create_table :course_talents do |t|
      t.string :status, null: false, default: "PENDING"
      t.references :course, null: false, foreign_key: true
      t.references :talent, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

  end
end

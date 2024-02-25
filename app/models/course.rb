class Course < ApplicationRecord
  belongs_to :author, class_name: 'Author', foreign_key: 'author_id'

  has_many :course_talents
  has_many :talents, through: :course_talents, source: :talent

  has_many :learning_path_courses
  has_many :learning_paths, through: :learning_path_courses, source: :learning_path

  validates :title, presence: true
end

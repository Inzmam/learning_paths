class LearningPath < ApplicationRecord
  has_many :learning_path_courses
  has_many :courses, through: :learning_path_courses, source: :course

  has_many :learning_path_talents
  has_many :talents, through: :learning_path_talents, source: :talent
end

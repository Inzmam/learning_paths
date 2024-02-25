class Talent < User
  has_many :course_talents
  has_many :courses, through: :course_talents, source: :course

  has_many :learning_path_talents
  has_many :courses, through: :learning_path_talents, source: :course
end

class CourseTalent < ApplicationRecord
  belongs_to :course
  belongs_to :talent, class_name: 'User'

  after_update :assign_to_next_course, if: -> { saved_change_to_attribute?(:status) && status == 'COMPLETED' }

  private

  def assign_to_next_course
    next_course = find_next_course_in_sequence

    if next_course
      CourseTalent.create(course: next_course, talent: talent)
    end
  end

  def find_next_course_in_sequence
    current_sequence_number = course.sequence_number
    next_course = LearningPathCourse.where(learning_path_id: course.learning_path.id).where("sequence_number > ?", current_sequence_number).order(:sequence_number).first.course

    if next_course.blank?
      # Learning Path is complete
    end

    next_course
  end
end

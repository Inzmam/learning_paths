class Api::V1::LearningPathsController < Api::V1::BaseController
  before_action :set_learning_path, only: [:show, :update, :destroy, :add_course, :remove_course]

  def index
    @learning_paths = LearningPath.all
  end

  def show
  end

  def create
    @learning_path = LearningPath.new(learning_path_params)

    if @learning_path.save
      # render jbuilder file
    else
      render json: { errors: @learning_path.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @learning_path.update(learning_path_params)
      render json: @learning_path
    else
      render json: { errors: @learning_path.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def add_course
    # Checked
    unless params[:course_id].present?
      render json: { error: 'Course ID is required' }, status: :unprocessable_entity
      return
    end
  
    @course = Course.find_by(id: params[:course_id])
  
    unless @course
      render json: { error: 'Course not found' }, status: :not_found
      return
    end

    if @learning_path.courses.include?(@course)
      render json: { error: 'Course already added to learning path' }, status: :unprocessable_entity
      return
    end

    sequence_number = params[:sequence_number].to_i
    learning_path_course = @learning_path.learning_path_courses.new(course_id: @course.id)

    latest_sequence_number = @learning_path.learning_path_courses.maximum(:sequence_number).to_i
    learning_path_course.sequence_number = latest_sequence_number + 1

    if learning_path_course.save  
      render json: { message: 'Course added to learning path successfully' }, status: :ok
    else
      render json: { error: 'Failed to add course to learning path' }, status: :unprocessable_entity
    end

  end

  def remove_course
    unless params[:course_id].present?
      render json: { error: 'course_id is required' }, status: :unprocessable_entity
      return
    end

    @course = Course.find_by(id: params[:course_id])

    if @course && @learning_path.courses.include?(@course)
      @learning_path.courses.delete(@course)
      render json: { message: 'Course removed from learning path successfully' }, status: :ok
    else
      render json: { error: 'Course not found in the learning path' }, status: :not_found
    end
  end

  private

  def set_learning_path
    @learning_path = LearningPath.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'LearningPath not found' }, status: :not_found
  end

  def learning_path_params
    params.require(:learning_path).permit(:name)
  end
end

class Api::V1::CoursesController < Api::V1::BaseController
  before_action :set_author, only: [:index, :show, :create, :update, :destroy, :add_talent, :remove_talent, :reassign_course, :mark_complete]

  def index
    # Checked
    @courses = @author.courses
  end

  def show
    # Checked
    @course = @author.courses.find_by(id: params[:id])

    if @course.blank?
      render json: { error: 'Course not found' }, status: :not_found
      return
    end
  end

  def create
    # Checked
    @course = @author.courses.new(course_params)

    if @course.save
      # render jbuilder
    else
      render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # Checked
    @course = @author.courses.find_by(id: params[:id])

    if @course.blank?
      render json: { error: 'Course not found' }, status: :not_found
      return
    end

    if @course.update(course_params)
      # render jbuilder
    else
      render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy
    head :no_content
  end

  def mark_complete
    talent_id = params[:talent_id]
  
    unless talent_id.present?
      render json: { error: 'Talent ID is required' }, status: :unprocessable_entity
      return
    end
  
    talent = Talent.find_by(id: talent_id)

    if talent.blank?
      render json: { error: 'Talent not found' }, status: :not_found
      return
    end

    @course = @author.courses.find_by(id: params[:id])
  
    if @course.blank?
      render json: { error: 'Course not found' }, status: :not_found
      return
    end

    course_talent = CourseTalent.find_by(course_id: @course.id, talent_id: talent_id)

    if course_talent.blank?
      render json: { error: 'Course and Talent are not associated' }, status: :not_found
      return
    end

    course_talent.status = 'COMPLETED'

    if course_talent.save
      render json: { message: 'Course marked as completed successfully' }, status: :ok
    else
      render json: { error: 'Failed to update course status', errors: @course.errors.full_messages }, status: :unprocessable_entity
    end

  end

  def reassign_course
    # Checked
    new_author_id = params[:new_author_id]
  
    unless new_author_id.present?
      render json: { error: 'New author ID is required' }, status: :unprocessable_entity
      return
    end
  
    new_author = Author.find_by(id: new_author_id)

    if new_author.blank?
      render json: { error: 'New author not found' }, status: :not_found
      return
    end

    course = Course.find_by(id: params[:id])

    if course.blank?
      render json: { error: 'Course not found' }, status: :not_found
      return
    end

    if already_assigned_to_author?(new_author)
      render json: { error: 'Course is already assigned to the new author' }, status: :unprocessable_entity
    else
      @author.courses.where(id: params[:id]).update(author_id: new_author.id)
      render json: { message: 'Courses reassigned successfully to the new author' }, status: :ok
    end

  end

  def add_talent
    # Checked
    unless params[:talent_id].present?
      render json: { error: 'Talent ID is required' }, status: :unprocessable_entity
      return
    end

    @course = @author.courses.find_by(id: params[:id])

    if @course.blank?
      render json: { error: 'Course not found' }, status: :not_found
      return
    end

    @talent = Talent.find_by(id: params[:talent_id])

    if @talent.blank?
      render json: { error: 'Talent not found' }, status: :not_found
      return
    end

    if @course.talents.include?(@talent)
      render json: { error: 'Talent already added to course' }, status: :unprocessable_entity
    else
      @course.talents << @talent
      if @course.save
        render json: { message: 'Talent added to course successfully' }, status: :ok
      else
        render json: { error: 'Failed to add talent to course' }, status: :unprocessable_entity
      end
    end
  end

  def remove_talent
    # Checked
    unless params[:talent_id].present?
      render json: { error: 'Talent ID is required' }, status: :unprocessable_entity
      return
    end

    @course = @author.courses.find_by(id: params[:id])
  
    if @course.blank?
      render json: { error: 'Course not found' }, status: :not_found
      return
    end
  
    @talent = Talent.find_by(id: params[:talent_id])
  
    if @talent.blank?
      render json: { error: 'Talent not found' }, status: :not_found
      return
    end
  
    if @course.talents.include?(@talent)
      @course.talents.delete(@talent)
      render json: { message: 'Talent removed from course successfully' }, status: :ok
    else
      render json: { error: 'Talent is not associated with the course' }, status: :unprocessable_entity
    end
  end

  private

  def set_course
    @course = @author.courses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

  def set_author
    @author = Author.find(params[:author_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Author not found' }, status: :not_found
  end

  def already_assigned_to_author?(new_author)
    @author.courses.where(author_id: new_author.id).exists?
  end

  def course_params
    params.require(:course).permit(:title)
  end
end

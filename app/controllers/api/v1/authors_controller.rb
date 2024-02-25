class Api::V1::AuthorsController < Api::V1::BaseController
  before_action :set_author, only: [:show, :update, :destroy]

  def index
    # Checked
    @authors = Author.all
  end

  def show
    # Checked
  end

  def create
    # Checked
    @author = Author.new(author_params)

    if @author.save
      # render jbuilder
    else
      render json: { errors: @author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # Checked
    if @author.update(author_params)
      # render jbuilder
    else
      render json: { errors: @author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    # Checked
    if @author.courses.present?
      render json: { error: 'Cannot delete author with associated courses. Reassign courses to other authors first.' }, status: :unprocessable_entity
    else
      @author.destroy
      render json: { message: 'Author deleted successfully' }, status: :ok
    end
  end

  private

  def set_author
    @author = Author.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Author not found' }, status: :not_found
  end

  def author_params
    params.require(:author).permit(:name, :email)
  end
end

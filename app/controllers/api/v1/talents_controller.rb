class Api::V1::TalentsController < Api::V1::BaseController
  before_action :set_talent, only: [:show, :update, :destroy]

  def index
    # Checked
    @talents = Talent.all
    # render jbuilder
  end

  def show
    # render jbuilder
  end

  def create
    # Checked
    @talent = Talent.new(talent_params)

    if @talent.save
      # render jbuilder
    else
      render json: { errors: @talent.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # Checked
    if @talent.update(talent_params)
      # render jbuilder
    else
      render json: { errors: @talent.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @talent.destroy
    head :no_content
  end

  private

  def set_talent
    @talent = Talent.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Talent not found' }, status: :not_found
  end

  def talent_params
    params.require(:talent).permit(:name, :email)
  end
end

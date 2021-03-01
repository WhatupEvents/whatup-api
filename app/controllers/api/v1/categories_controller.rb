class Api::V1::CategoriesController < Api::V1::ApiController
  before_action :doorkeeper_authorize!

  def index
    render json: Category.all,
           each_serializer: Api::V1::CategorySerializer,
           status: :ok
  end
end

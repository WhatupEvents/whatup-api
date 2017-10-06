class Api::V1::CategoriessController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    render json: Category.all,
           each_serializer: Api::V1::CategorySerializer,
           status: :ok
  end
end

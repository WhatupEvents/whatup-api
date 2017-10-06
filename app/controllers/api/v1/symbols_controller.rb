class Api::V1::SymbolsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    render json: Symbol.all,
           serializer: Api::V1::SymbolSerializer,
           status: :ok
  end
end

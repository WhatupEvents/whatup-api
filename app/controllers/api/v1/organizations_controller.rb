class Api::V1::OrganizationsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    render json: Organization.all,
           each_serializer: Api::V1::OrganizationSerializer,
           status: :ok
  end
end

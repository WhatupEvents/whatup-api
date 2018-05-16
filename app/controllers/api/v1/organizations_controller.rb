class Api::V1::OrganizationsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    render json: current_user.organizations,
           each_serializer: Api::V1::OrganizationSerializer,
           status: :ok
  end
end

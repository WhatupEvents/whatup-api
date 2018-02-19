class Api::V1::OrganizationsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    if current_user.role != 'Promoter'
      head :bad_request
      return
    end

    render json: Organization.all,
           each_serializer: Api::V1::OrganizationSerializer,
           status: :ok
  end
end

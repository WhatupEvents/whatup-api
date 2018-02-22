class Api::V1::OrganizationsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    organizations = current_user.organizations
    if current_user.role != 'Promoter' && current_user.role != 'Admin'
      head :bad_request
      return
    end

    if current_user.role == 'Admin'
      organizations = Organization.all
    end

    render json: organizations,
           each_serializer: Api::V1::OrganizationSerializer,
           status: :ok
  end
end

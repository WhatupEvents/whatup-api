class Api::V1::OrganizationsController < Api::V1::ApiController
  before_action :doorkeeper_authorize!

  def index
    render json: current_user.admin? ? Organization.all : current_user.organizations,
           each_serializer: Api::V1::OrganizationSerializer,
           status: :ok
  end
end

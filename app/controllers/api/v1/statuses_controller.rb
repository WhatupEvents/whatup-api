class Api::V1::StatusesController < Api::V1::ApiController
  doorkeeper_for :all

  def create
    Status.create! status_params
    head :created
  end

  def up
    status = Status.find(User.find(status_params[:user_id]).statuses.current.last.id)
    upped_by = User.find(status_params[:upped_by])
    if !status.upped_by.include? upped_by
      status.upped_by.push upped_by
      status.ups += 1
      status.save
    end
  end

  def status_params
    params.require(:status).permit(:user_id, :symbol_id, :text, :upped_by, :ups)
  end
end

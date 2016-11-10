class Api::V1::StatusesController < Api::V1::ApiController
  doorkeeper_for :all

  def most_upped
    most = Status.where(symbol_id: params[:cat_id]).sort_by(&:ups)
    most = Status.all.sort_by(&:ups) unless most.present?

    render json: most.last,
           serializer: Api::V1::StatusSerializer,
           status: :ok
  end

  def create
    status = Status.create! status_params
    status.update_attribute(:text, status.text.capitalize)
    head :created
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
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

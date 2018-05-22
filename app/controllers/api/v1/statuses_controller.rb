class Api::V1::StatusesController < Api::V1::ApiController
  doorkeeper_for :all

  def most_upped
    most = Status.where(topic_id: params[:cat_id]).sort_by(&:ups)
    most = Status.all.sort_by(&:ups) unless most.present?

    render json: most.last,
           serializer: Api::V1::StatusSerializer,
           status: :ok
  end

  def create
    status = Status.create! status_params
    status.update_attribute(:text, status.text.capitalize)
    if Rails.env != "development"
      current_user.friends.each do |friend|
        Resque.enqueue(
          FcmMessageJob,{ 
            status_id: status.id,
            status_text: status.text,
            user_id: current_user.id,
            user_name: current_user.name,
            recipient_id: friend.id
          }
        )
      end
    end
    render json: status,
           serializer: Api::V1::StatusSerializer,
           status: :created
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def up
    upping_friend = User.find(status_params[:user_id])
    status = Status.find(upping_friend.statuses.current.last.id)

    unless status.upped_by.include? current_user
      status.upped_by.push current_user
      status.ups += 1

      if Rails.env != "development"
        Resque.enqueue(
          FcmMessageJob, {
            ups: status.ups,
            status_id: status.id,
            recipient_id: upping_friend.id
          }
        )
      end 

      status.save
    end

    render json: status,
           serializer: Api::V1::StatusSerializer,
           status: :ok
  end

  def status_params
    # Remove this after app updates are out
    # Also update serializer
    if params[:status].has_key? :symbol_id
      params[:status][:topic_id] = params[:status][:symbol_id]
    end
    params.require(:status).permit(:user_id, :topic_id, :text, :ups, :valid_until)
  end
end

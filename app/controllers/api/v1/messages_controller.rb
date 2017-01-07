class Api::V1::MessagesController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    last = message_params.has_key?(:last_id) ? Message.find(message_params.delete(:last_id)) : Message.last
    messages = Message.where(event_id: message_params[:event_id])
      .where('created_at <= ?', last.created_at)
      .limit(50).order(created_at: :desc)
    
    return_messages(messages)
  end

  def random
    messages = Message.where(event_id: message_params[:event_id]).random
    return_messages(messages)
  end

  def download
    Rails.logger.info params[:image_url]
    object_key = params[:image_url].split('whatupevents-images/')[1]
    Rails.logger.info object_key

    obj = Object.new(
      bucket_name: 'whatupevents-images',
      key: object_key,
      access_key_id: "AKIAJSKGHQFVPEXZZGMA",
      secret_access_key: "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"
      region: 'us-east-2',
    })

    url = obj.presigned_url(:get, expires_in: 300)
    Rails.logger.info url
    redirect_to url
  end

  private

  def return_messages(messages)
    if messages.present?
      render json: messages,
             each_serializer: Api::V1::MessageSerializer,
             status: :ok
    else
      head :not_found
    end
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def message_params
    params.require(:messages).permit(:my_id, :event_id, :last_id)
  end
end

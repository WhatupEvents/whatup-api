class Api::V1::MessagesController < Api::V1::ApiController
  before_action :doorkeeper_authorize!, except: [:download]

  def index
    last = message_params.has_key?(:last_id) ? Message.find(message_params.delete(:last_id)) : Message.last
    messages = Message.where(event_id: message_params[:event_id])
      .where('created_at <= ?', last.created_at)
      .limit(50).order(created_at: :desc).not_flagged_for(current_user.id)
    
    return_messages(messages)
  end

  def random
    messages = Message.where(event_id: message_params[:event_id]).random
    return_messages(messages)
  end

  def download
    object_key = params[:image_url].gsub('-','/').gsub('_','.')

    obj = Aws::S3::Object.new(
      bucket_name: 'whatupevents-images',
      key: object_key,
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY'],
      region: 'us-east-2'
    )

    signed_url = obj.presigned_url(:get, expires_in: 60*60*24*3)
    redirect_to signed_url
  end

  private

  def return_messages(messages)
    if messages.present?
      render json: messages,
             each_serializer: Api::V1::MessageSerializer,
             status: :ok
    else
      render json: {}, status: :not_found
    end
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def message_params
    params.require(:messages).permit(:my_id, :event_id, :last_id)
  end
end

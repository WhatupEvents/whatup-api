class Message < ActiveRecord::Base
  belongs_to :sender
  belongs_to :receiver
  belongs_to :event

  has_attached_file :image,
    :storage => :s3,
    :bucket => 'whatupevents-images',
    :s3_region => 'us-east-2',
    :s3_host_name => 's3.us-east-2.amazonaws.com',
    :s3_permissions => :private,
    :path => ':class/:attachment/:id/:filename',
    :s3_credentials => Proc.new{|p| p.instance.s3_credentials}
  do_not_validate_attachment_file_type :image

  def s3_credentials
    {
     access_key_id: ENV['AWS_ACCESS_KEY'],
     secret_access_key: ENV['AWS_SECRET_KEY']
    }
  end

  scope :random, lambda { group(:sender_id) }

  scope :not_flagged_for, ->(user_id) do
    select do |item|
      !Flag.where(obj_class: item.class.to_s, obj_id: item.id, user_id: user_id).present?
    end
  end
end

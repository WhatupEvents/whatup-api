class Message < ActiveRecord::Base
  belongs_to :sender
  belongs_to :receiver
  belongs_to :event

  has_attached_file :image,
    :storage => :s3,
    :bucket => "whatupevents-images",
    :s3_region => 'us-east-2',
    :s3_permissions => :private,
    :path => ":class/:attachment/:id/:filename",
    :s3_credentials => Proc.new{|p| p.instance.s3_credentials}
  do_not_validate_attachment_file_type :image

  def s3_credentials
    {
     access_key_id: "AKIAJSKGHQFVPEXZZGMA",
     secret_access_key: "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"
    }
  end

  scope :random, lambda { group(:sender_id) }
end

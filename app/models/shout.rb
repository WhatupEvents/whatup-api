class Shout < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  has_many :shout_uppings
  has_many :upped_by, class_name: 'User', through: :shout_uppings

  has_many :shout_flaggings
  has_many :flagged_by, class_name: 'User', through: :shout_flaggings

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
     access_key_id: "AKIAJSKGHQFVPEXZZGMA",
     secret_access_key: "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"
    }
  end

end

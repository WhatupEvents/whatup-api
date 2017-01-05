class Shout < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  has_attached_file :image,
    storage: :s3,
    :s3_region => 'us-east-2',
    s3_credentials: Proc.new{|p| p.instance.s3_credentials}
  do_not_validate_attachment_file_type :image

  def s3_credentials
    {
     bucket: "whatupevents-images",
     access_key_id: "AKIAIF5LMWPOUEEJMVCA",
     secret_access_key: "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"
    }
  end
end

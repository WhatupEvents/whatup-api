class ShoutVideo < ActiveRecord::Base
  belongs_to :shout

  has_attached_file :video,
    :storage => :s3,
    :bucket => 'whatupevents-videos',
    :s3_region => 'us-east-1',
    :s3_host_name => 's3.us-east-1.amazonaws.com',
    :path => ':class/:attachment/:id/:filename',
    :s3_credentials => Proc.new{|p| p.instance.s3_credentials}
  do_not_validate_attachment_file_type :video


  def s3_credentials
    {
     access_key_id: ENV['AWS_ACCESS_KEY'],
     secret_access_key: ENV['AWS_SECRET_KEY']
    }
  end

end

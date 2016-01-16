class Shout < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  has_attached_file :image
  do_not_validate_attachment_file_type :image
end

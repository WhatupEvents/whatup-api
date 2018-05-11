class Category < ActiveRecord::Base
  self.table_name = "symbols"

  has_many :topics, foreign_key: :topic_id
end

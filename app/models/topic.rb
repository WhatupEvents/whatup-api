class Topic < ActiveRecord::Base
  belongs_to :category, foreign_key: :symbol_id
end

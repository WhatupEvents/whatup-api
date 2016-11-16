class Api::V1::Me
  include ActiveModel::Serialization

  attr_accessor :attributes

  def initialize(attributes = {})
    @attributes = attributes
  end
end

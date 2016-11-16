module ActiveModel
  class Serializer
    module Associations
      remove_const(:DEFAULT_INCLUDE_TREE)
      DEFAULT_INCLUDE_TREE_STRING = '**'
      DEFAULT_INCLUDE_TREE = ActiveModel::Serializer::IncludeTree.from_string(DEFAULT_INCLUDE_TREE_STRING)
    end
  end
end

module ActiveModelSerializers
  module Adapter
    class Attributes < Base
      def initialize(serializer, options = {})
        super
        @include_tree = ActiveModel::Serializer::IncludeTree.from_include_args(options[:include] || ActiveModel::Serializer::Associations::DEFAULT_INCLUDE_TREE_STRING)
        @cached_attributes = options[:cache_attributes] || {}
      end
    end
  end
end

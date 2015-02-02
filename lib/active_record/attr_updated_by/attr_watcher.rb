require 'singleton'
module ActiveRecord
  module AttrUpdatedBy
    class AttrWatcher
      include Singleton
      def initialize
        @watched = {}
      end
      def watch(klass, atts={})
        atts.each do |att, attr_associations|
          @watched[klass.model_name] or @watched[klass.model_name] = {}
          @watched[klass.model_name][att] = attr_associations
        end
      end
      def watched(klass)
        @watched[klass.model_name]
      end
    end
  end
end

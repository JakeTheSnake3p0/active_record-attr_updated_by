require 'singleton'
module ActiveRecord
  module AttrUpdatedBy
    class AttrWatcher
      include Singleton

      def initialize
        @watched = {}
      end

      def watch(klass, atts={})
        c = class_name(klass)
        atts.each do |att, attr_associations|
          @watched[c] or @watched[c] = {}
          @watched[c][att] = attr_associations
        end
      end

      def watched(klass)
        @watched[class_name(klass)]
      end

      def watching?(klass)
        # Due to the after_initialize hook, we may
        # need to pass in the class as a string 
        # instead of the object itself
        @watched.keys.include? klass.is_a?(String) ? klass : class_name(klass)
      end

      # We can't use AR's model_name - it will cause it
      # to load and trigger an infinite loop!
      def class_name(klass)
        c = klass.class.to_s
        # If it didn't return a constant, or it returned some generic "Class" crap...
        c = klass.class.name if !defined?(c) || c == "Class"
        # Last resort! Try #inspect w regex
        c = /^([\w:]+)\s?\(/.match(klass.inspect)[1] if !defined?(c) || c == "Class"
        c
      end
    end
  end
end

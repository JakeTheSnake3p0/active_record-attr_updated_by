require 'active_record'
require 'active_record/attr_updated_by/attr_watcher'
require 'active_record/attr_updated_by/version'

module ActiveRecord
  module AttrUpdatedBy
    extend ActiveSupport::Concern

    included do
      before_save :attr_updated_by_update_timestamps!, if: proc { AttrWatcher.instance.watching?(self) }
      after_initialize :check_arguments!, if: proc { AttrWatcher.instance.watching?(self) }
    end

    module ClassMethods
      def updates_timestamp_on(att, args = {})
        AttrWatcher.instance.watch self, att => (args[:using] || []).flat_map(&:to_sym)
      end
    end

    def attr_updated_by_update_timestamps!
      AttrWatcher.instance.watched(self).each do |att, attr_associations|
        if attr_associations.empty?
          # Update the attribute if anything
          # in the instance has changed
          self[att] = current_time_from_proper_timezone if changed?
          next
        end
        # Update the attribute based on its associations
        if attr_associations.any? { |association| send("#{ association }_changed?") }
          self[att] = current_time_from_proper_timezone
        end
      end
    end

    def check_arguments!
      # Do not affect classes which are not using attr_updated_by
      # Validate presence of methods!
      AttrWatcher.instance.watched(self).each do |att, attr_associations|
        # The attribute being updated must exist in the database
        if self.class.column_names.include?(att.to_s)
          # Type checking on instantiation of object
          if has_attribute?(att)
            unless self[att].is_a?(Time) || self[att].is_a?(DateTime) || self[att].is_a?(NilClass)
              raise(ArgumentError, 'must be a timestamp')
            end
          else
            # If the attribute isn't loaded, don't check for associations.
            # The attribute may not have been loaded for a reason
            next
          end
        else
          raise UnknownAttributeError.new(self, att)
        end
        attr_associations.each do |association|
          # The associated methods must also exist
          raise UnknownAttributeError.new(self, association) unless has_attribute?(association)
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::AttrUpdatedBy

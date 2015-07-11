module ActiveRecord::Userstamp::Stamper
  extend ActiveSupport::Concern

  module ClassMethods
    def model_stamper
      # don't allow multiple calls
      return if self.included_modules.include?(ActiveRecord::Userstamp::Stamper::InstanceMethods)
      send(:extend, ActiveRecord::Userstamp::Stamper::InstanceMethods)
    end
  end

  module InstanceMethods
    # Used to set the stamper for a particular request. See the Userstamp module for more
    # details on how to use this method.
    def stamper=(object)
      object_stamper = if object.is_a?(ActiveRecord::Base)
        object.send("#{object.class.primary_key}".to_sym)
      else
        object
      end

      Thread.current[stamper_identifier] = object_stamper
    end

    # Retrieves the existing stamper for the current request.
    def stamper
      Thread.current[stamper_identifier]
    end

    # Sets the stamper back to +nil+ to prepare for the next request.
    def reset_stamper
      Thread.current[stamper_identifier] = nil
    end

    private

    def stamper_identifier
      "#{self.to_s.downcase}_#{self.object_id}_stamper"
    end
  end
end

module ActiveRecord::Userstamp::Stamper
  extend ActiveSupport::Concern

  module ClassMethods
    def model_stamper
      # don't allow multiple calls
      return if singleton_class.included_modules.include?(InstanceMethods)
      extend ActiveRecord::Userstamp::Stamper::InstanceMethods
    end
  end

  module InstanceMethods
    # Used to set the current stamper for this model.
    #
    # @overload stamper=(object_id)
    #   @param [Fixnum] object_id The ID of the stamper.
    #   @return [Fixnum]
    # @overload stamper=(object)
    #   @param [ActiveRecord::Base] object The stamper object.
    #   @return [ActiveRecord::Base]
    def stamper=(object)
      Thread.current[stamper_identifier] = object
    end

    # Retrieves the existing stamper.
    def stamper
      Thread.current[stamper_identifier]
    end

    # Sets the stamper back to +nil+ to prepare for the next request.
    def reset_stamper
      self.stamper = nil
    end

    # For the duration that execution is within the provided block, the stamper for this class
    # would be the specified value.
    #
    # This replaces the {#stamper=} and {#reset_stamper} pair because this guarantees exception
    # safety.
    def with_stamper(stamper)
      old_stamper = self.stamper
      self.stamper = stamper
      yield
    ensure
      self.stamper = old_stamper
    end

    private

    def stamper_identifier
      "#{self.to_s.downcase}_#{self.object_id}_stamper"
    end
  end
end

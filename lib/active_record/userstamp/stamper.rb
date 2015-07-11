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
      ActiveSupport::Deprecation.warn(<<-MSG.squish)
        `stamper=` is deprecated and will be removed in ActiveRecord::Userstamp 3.1; use
        `push_stamper` instead.
      MSG

      stamper_stack.clear
      push_stamper(object) if object
      object
    end

    # Retrieves the existing stamper.
    def stamper
      stamper_stack.last
    end

    # Sets the stamper back to +nil+ to prepare for the next request.
    def reset_stamper
      stamper_stack.clear
    end

    # Pushes the provided stamper onto the stamper stack.
    #
    # Call {#pop_stamper} to restore the previous stamper.
    #
    # @overload push_stamper(object_id)
    #   @param [Fixnum] object_id The ID of the stamper.
    #   @return [void]
    # @overload push_stamper(object)
    #   @param [ActiveRecord::Base] object The stamper object.
    #   @return [void]
    def push_stamper(object)
      stamper_stack.push(object)
    end

    # Pops the last stamper from the stamper stack.
    #
    # @return [void]
    def pop_stamper
      stamper_stack.pop
    end

    private

    def stamper_stack
      Thread.current[stamper_identifier] ||= []
    end

    def stamper_identifier
      "#{self.to_s.downcase}_#{self.object_id}_stamper"
    end
  end
end

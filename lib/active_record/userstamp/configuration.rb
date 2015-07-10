module ActiveRecord::Userstamp::Configuration
  # Determines what default columns to use for recording the current stamper.
  # By default this is set to false, so the plug-in will use columns named
  # <tt>creator_id</tt>, <tt>updater_id</tt>, and <tt>deleter_id</tt>.
  #
  # To turn compatibility mode on, place the following line in your environment.rb
  # file:
  #
  #   Ddb::Userstamp.compatibility_mode = true
  #
  # This will cause the plug-in to use columns named <tt>created_by</tt>,
  # <tt>updated_by</tt>, and <tt>deleted_by</tt>.
  mattr_accessor :compatibility_mode
  @@compatibility_mode = false

  class << self
    private

    # Defines an attribute configuration that is delegated to ActiveRecord::Base
    def attribute_config(attribute)
      class_eval do
        attribute_writer = "#{attribute}_attribute=".to_sym
        attribute = "#{attribute}_attribute".to_sym
        define_singleton_method(attribute) do
          ActiveRecord::Base.send(attribute)
        end

        define_singleton_method(attribute_writer) do |attribute|
          ActiveRecord::Base.send(attribute_writer, attribute)
        end
      end
    end
  end

  # !@attribute [rw] creator_attribute
  #   Determines the name of the column in the database which stores the name of the creator.
  #
  #   Override the attribute by using the stampable class method within a model.
  #
  #   By default, this is set to +:creator_id+.
  attribute_config :creator
  self.creator_attribute = compatibility_mode ? :created_by : :creator_id

  # !@attribute [rw] updater_attribute
  #   Determines the name of the column in the database which stores the name of the updater.
  #
  #   Override the attribute by using the stampable class method within a model.
  #
  #   By default, this is set to +:updater_id+.
  attribute_config :updater
  self.updater_attribute = compatibility_mode ? :updated_by: :updater_id

  # !@attribute [rw] deleter_attribute
  #   Determines the name of the column in the database which stores the name of the deleter.
  #
  #   Override the attribute by using the stampable class method within a model.
  #
  #   By default, this is set to +:deleter_id+.
  attribute_config :deleter
  self.deleter_attribute = compatibility_mode ? :deleted_by : :deleter_id
end

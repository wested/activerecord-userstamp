module ActiveRecord::Userstamp::Configuration
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
  self.creator_attribute = :creator_id

  # !@attribute [rw] updater_attribute
  #   Determines the name of the column in the database which stores the name of the updater.
  #
  #   Override the attribute by using the stampable class method within a model.
  #
  #   By default, this is set to +:updater_id+.
  attribute_config :updater
  self.updater_attribute = :updater_id

  # !@attribute [rw] deleter_attribute
  #   Determines the name of the column in the database which stores the name of the deleter.
  #
  #   Override the attribute by using the stampable class method within a model.
  #
  #   By default, this is set to +nil+.
  attribute_config :deleter
end

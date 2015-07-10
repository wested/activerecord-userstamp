module ActiveRecord::Userstamp::Configuration
  # !@attribute [rw] creator_attribute
  #   Determines the name of the column in the database which stores the name of the creator.
  #
  #   Override the attribute by using the stampable class method within a model.
  #
  #   By default, this is set to +:creator_id+.
  mattr_accessor :creator_attribute
  self.creator_attribute = :creator_id

  # !@attribute [rw] updater_attribute
  #   Determines the name of the column in the database which stores the name of the updater.
  #
  #   Override the attribute by using the stampable class method within a model.
  #
  #   By default, this is set to +:updater_id+.
  mattr_accessor :updater_attribute
  self.updater_attribute = :updater_id

  # !@attribute [rw] deleter_attribute
  #   Determines the name of the column in the database which stores the name of the deleter.
  #
  #   Override the attribute by using the stampable class method within a model.
  #
  #   By default, this is set to +:deleter_id+.
  mattr_accessor :deleter_attribute
  self.deleter_attribute = :deleter_id
end

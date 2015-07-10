module ActiveRecord::Userstamp::MigrationHelper
  extend ActiveSupport::Concern

  def userstamps(include_deleted_by = false, *args)
    column(ActiveRecord::Userstamp.config.creator_attribute, :integer, *args)
    column(ActiveRecord::Userstamp.config.updater_attribute, :integer, *args)
    column(ActiveRecord::Userstamp.config.deleter_attribute, :integer, *args) if include_deleted_by
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.class_eval do
  include ActiveRecord::Userstamp::MigrationHelper
end

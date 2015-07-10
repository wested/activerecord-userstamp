module ActiveRecord::Userstamp::MigrationHelper
  extend ActiveSupport::Concern

  def userstamps(include_deleted_by = false, *args)
    compatibility_mode = ActiveRecord::Userstamp.config.compatibility_mode
    column(compatibility_mode ? :created_by : :creator_id, :integer, *args)
    column(compatibility_mode ? :updated_by : :updater_id, :integer, *args)
    column(compatibility_mode ? :deleted_by : :deleter_id, :integer, *args) if include_deleted_by
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.class_eval do
  include ActiveRecord::Userstamp::MigrationHelper
end

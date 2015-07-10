module ActiveRecord::Userstamp::MigrationHelper
  extend ActiveSupport::Concern

  def userstamps(include_deleted_by = false, *args)
    column(:creator_id, :integer, *args)
    column(:updater_id, :integer, *args)
    column(:deleter_id, :integer, *args) if include_deleted_by
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.class_eval do
  include ActiveRecord::Userstamp::MigrationHelper
end

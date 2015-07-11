# Test group helpers for creating tables.
# The latest version can be gound at https://gist.github.com/lowjoel/bda0d44b48aac2925079
module ActiveRecord::TemporaryTable; end
module ActiveRecord::TemporaryTable::TestGroupHelpers
  # Defines a temporary table that is instantiated when needed, within a `with_temporary_table`
  # block.
  #
  # @param [Symbol] table_name The name of the table to define.
  # @param [Proc] proc The table definition, same as that of a block given to
  #   +ActiveRecord::Migration::create_table+
  def temporary_table(table_name, &proc)
    define_method(table_name) do
      proc
    end
  end

  # Using the temporary table defined previously, run the examples in this group.
  #
  # @param [Symbol] table_name The name of the table to use.
  # @param [Symbol] create_at When to create the table. Defaults to :context.
  # @param [Proc] proc The examples requiring the use of the temporary table.
  def with_temporary_table(table_name, create_at = :context, &proc)
    context "with temporary table #{table_name}" do |*params|
      before(create_at) do
        ActiveRecord::TemporaryTable::TestGroupHelpers.create_table(table_name, send(table_name))
      end

      after(create_at) do
        ActiveRecord::TemporaryTable::TestGroupHelpers.drop_table(table_name)
      end

      module_exec(*params, &proc)
    end
  end

  def self.create_table(table_name, table_definition)
    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Migration.create_table(table_name, &table_definition)
    end
  end

  def self.drop_table(table_name)
    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Migration.drop_table(table_name)
    end
  end
end

RSpec.configure do |config|
  config.extend ActiveRecord::TemporaryTable::TestGroupHelpers, type: :model
end

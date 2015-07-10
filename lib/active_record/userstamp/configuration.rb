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
end

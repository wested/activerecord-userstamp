module ActiveRecord::Userstamp
  extend ActiveSupport::Autoload

  autoload :Configuration
  autoload :Stampable
  autoload :Stamper
  autoload :Utilities

  eager_autoload do
    autoload :ControllerAdditions
    autoload :MigrationAdditions
    autoload :ModelAdditions
  end

  # Retrieves the configuration for the userstamp gem.
  #
  # @return [ActiveRecord::Userstamp::Configuration]
  def self.config
    Configuration
  end

  # Configures the gem.
  #
  # @yield [ActiveRecord::Userstamp::Configuration] The configuration for the gem.
  def self.configure
    yield config
  end

  eager_load!
end

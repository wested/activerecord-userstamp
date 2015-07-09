module ActiveRecord::Userstamp
  extend ActiveSupport::Autoload

  autoload :Stampable
  autoload :Stamper

  eager_autoload do
    autoload :ControllerAdditions
    autoload :MigrationAdditions
    autoload :ModelAdditions
  end
end

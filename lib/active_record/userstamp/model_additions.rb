module ActiveRecord::Userstamp::ModelAdditions
  extend ActiveSupport::Concern

  include ActiveRecord::Userstamp::Stampable
  include ActiveRecord::Userstamp::Stamper
end

ActiveRecord::Base.class_eval do
  include ActiveRecord::Userstamp::ModelAdditions
end

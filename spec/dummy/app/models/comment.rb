# this class is only meant for compatability mode testing
class Comment < ActiveRecord::Base
  stampable   stamper_class_name: :person, creator_attribute: :created_by,
              updater_attribute: :updated_by, deleter_attribute: :deleted_by
  belongs_to  :post
end

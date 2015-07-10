# Extends the stamping functionality of ActiveRecord by automatically recording the model
# responsible for creating, updating, and deleting the current object. See the +Stamper+ and
# +ControllerAdditions+ modules for further documentation on how the entire process works.
module ActiveRecord::Userstamp::Stampable
  extend ActiveSupport::Concern

  included do
    # Should ActiveRecord record userstamps? Defaults to true.
    class_attribute  :record_userstamp
    self.record_userstamp = true

    class_attribute  :stamper_class_name
  end

  module ClassMethods
    # This method is automatically called on for all classes that inherit from
    # ActiveRecord, but if you need to customize how the plug-in functions, this is the
    # method to use. Here's an example:
    #
    #   class Post < ActiveRecord::Base
    #     stampable :stamper_class_name => :person,
    #               :with_deleted       => true
    #   end
    #
    # The method will automatically setup all the associations,
    # and create <tt>before_validation</tt> & <tt>before_destroy</tt> callbacks for doing the stamping.
    #
    # By default, the deleter association and before filter are not defined unless
    # you set the :deleter_attribute or set the :deleter option to true.
    #
    # When using the new acts_as_paranoid gem (https://github.com/goncalossilva/rails3_acts_as_paranoid)
    # the :with_deleted option can be used to setup the associations to return objects that have been soft deleted.
    #
    def stampable(options = {})
      self.stamper_class_name = options.delete(:stamper_class_name) if options.key?(:stamper_class_name)

      class_eval do
        config = ActiveRecord::Userstamp.config

        klass = stamper_class.try(:name)
        relation_options = options.reverse_merge(class_name: klass)
        belongs_to :creator, relation_options.reverse_merge(foreign_key: config.creator_attribute)
        belongs_to :updater, relation_options.reverse_merge(foreign_key: config.updater_attribute)

        before_validation :set_updater_attribute
        before_validation :set_creator_attribute, on: :create
        before_save :set_updater_attribute
        before_save :set_creator_attribute, on: :create

        if config.deleter_attribute
          belongs_to :deleter, relation_options.reverse_merge(foreign_key: config.deleter_attribute)

          before_destroy :set_deleter_attribute
        end
      end
    end

    # Temporarily allows you to turn stamping off. For example:
    #
    #   Post.without_stamps do
    #     post = Post.find(params[:id])
    #     post.update_attributes(params[:post])
    #     post.save
    #   end
    def without_stamps
      original_value = self.record_userstamp
      self.record_userstamp = false
      yield
    ensure
      self.record_userstamp = original_value
    end

    def stamper_class #:nodoc:
      stamper_class_name.to_s.camelize.constantize rescue nil
    end
  end

  private

  def has_stamper?
    !self.class.stamper_class.nil? && !self.class.stamper_class.stamper.nil? rescue false
  end

  def set_creator_attribute
    return unless self.record_userstamp
    if respond_to?(ActiveRecord::Userstamp.config.creator_attribute) && has_stamper?
      if self.send(ActiveRecord::Userstamp.config.creator_attribute).blank?
        self.send("#{ActiveRecord::Userstamp.config.creator_attribute}=", self.class.stamper_class.stamper)
      end
    end
  end

  def set_updater_attribute
    return unless self.record_userstamp
    # only set updater if the record is new or has changed
    # or contains a serialized attribute (in which case the attribute value is always updated)
    return unless self.new_record? || self.changed? || self.class.serialized_attributes.present?
    if respond_to?(ActiveRecord::Userstamp.config.updater_attribute) && has_stamper?
      self.send("#{ActiveRecord::Userstamp.config.updater_attribute}=", self.class.stamper_class.stamper)
    end
  end

  def set_deleter_attribute
    return unless self.record_userstamp
    if respond_to?(ActiveRecord::Userstamp.config.deleter_attribute) && has_stamper?
      self.send("#{ActiveRecord::Userstamp.config.deleter_attribute}=", self.class.stamper_class.stamper)
      save
    end
  end
end

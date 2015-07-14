module ActiveRecord::Userstamp::Utilities
  # Removes the association methods from the model.
  #
  # @param [Class] model The model to remove methods from.
  # @param [Symbol] association The name of the association to remove.
  # @return [void]
  def self.remove_association(model, association)
    methods = [
      association,
      "#{association}=",
      "build_#{association}",
      "create_#{association}",
      "create_#{association}!"
    ]

    model.generated_association_methods.module_eval do
      methods.each do |method|
        remove_method(method) if method_defined?(method)
      end
    end
  end

  # Obtains the creator/updater/deleter columns which are present in the model.
  #
  # @param [Class] model The model to query.
  # @return [nil|Array<(bool, bool, bool)>] Nil if the model does not have a table defined.
  #   Otherwise, a tuple of booleans indicating the presence of the created, updated, and deleted
  #   columns.
  def self.available_association_columns(model)
    return nil if model.table_name.empty?
    columns = Set[*model.column_names]
    config = ActiveRecord::Userstamp.config

    [config.creator_attribute.present? && columns.include?(config.creator_attribute.to_s),
     config.updater_attribute.present? && columns.include?(config.updater_attribute.to_s),
     config.deleter_attribute.present? && columns.include?(config.deleter_attribute.to_s)]
  rescue ActiveRecord::StatementInvalid => _
    nil
  end

  # Assigns the given attribute to the record, based on the model's stamper.
  #
  # If the stamper is a record, then it is assigned to the attribute; if it is a number, then it
  # is assigned to the +_id+ attribute
  #
  # @param [ActiveRecord::Base] record The record to assign.
  # @param [Symbol] attribute The attribute to assign.
  def self.assign_attribute(record, attribute)
    attribute = attribute.to_s
    stamp_value = record.class.stamper_class.stamper

    attribute = attribute[0..-4] if !stamp_value.is_a?(Fixnum) && attribute.end_with?('_id')
    record.send("#{attribute}=", stamp_value)
  end
end

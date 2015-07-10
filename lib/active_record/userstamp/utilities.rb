module ActiveRecord::Userstamp::Utilities
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
end


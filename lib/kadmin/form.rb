module Kadmin
  # Parsing is done by using attribute setters. If you have an attribute called
  # name, then add a reader/writer for it, name and name=, and perform the
  # parsing in name=. If there is no parsing to be done, you can simply delegate
  # the method to the underlying model.
  #
  # If the attribute is a nested form, in the writer, simply instantiate that
  # form, and pass the attributes on to it, then update the model's association
  # (if any) to reflect the changes.
  #
  # Validation is performed like on a normal model or ActiveRecord object.
  # If you have no extra validation to perform than that of the model, simply
  # delegate the validate and valid? methods to the model.
  #
  # To use nested forms, you need to add a reader and a writer. For example,
  # for a form called Person, with potentially X nested Person forms as children,
  # you would have:
  # class Person
  #   def children
  #     [@child1, @child2]
  #   end
  #
  #   def children_attributes=(attributes)
  #     ...instantiate subforms and pass attributes...
  #   end
  # end
  class Form
    # Provides common validators and methods to add custom ones
    include ActiveModel::Validations

    # Provides translation scope and helpers (useful for error messages)
    # Also includes ActiveModel::Naming at the same time
    extend ActiveModel::Translation

    # @return [ActiveModel::Model] underlying model to populate
    attr_reader :model

    delegate :id, :persisted?, to: :model

    def initialize(model)
      @errors = ActiveModel::Errors.new(self)
      @model = model
      @form_input = {}
    end

    # @!group Parsing/Deserialization

    # Populates the model based on the form input. The input is typically obtained
    # from the controller's params method, but can be any hash which conforms to
    # whatever the form object is expecting.
    # If some input was previously parsed, there is no "rollback" on the state
    # of the model; it should be done prior to reparsing if it is necessary.
    # @param [Hash<String, Object>] form_input a hash representing the raw form input
    def assign_attributes(form_input)
      @errors.clear
      form_input.each do |attr, value|
        setter = "#{attr}="
        send(setter, value) if respond_to?(setter)
      end
    end

    # @!endgroup
  end
end

# TODO: Figure out a way to not have to require ActiveModel/ActiveRecord preemptively
# perhaps by making Kadmin::Form optionally requireable?
require 'active_model/naming'
require 'active_model/callbacks'
require 'active_model/translation'
require 'active_model/validator'
require 'active_model/validations'
require 'active_record/attribute_assignment'

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
  # @example
  #   class PersonForm < Form
  #     def children
  #       [@child1, @child2]
  #     end
  #
  #     def children_attributes=(attributes)
  #       ...instantiate subforms and pass attributes...
  #     end
  #   end
  class Form
    # Provides common validators and methods to add custom ones
    include ActiveModel::Validations

    # Provides translation scope and helpers (useful for error messages)
    # Also includes ActiveModel::Naming at the same time
    extend ActiveModel::Translation

    # @return [ActiveModel::Model] underlying model to populate
    attr_reader :model

    delegate :id, :persisted?, :to_key, :to_query, :to_param, :type_for_attribute, to: :model

    def initialize(model)
      @errors = ActiveModel::Errors.new(self)
      @model = model
      @form_input = {}
    end

    def to_model
      return @model
    end

    # @!group Attributes assignment/manipulation

    # Allows parsing of multi parameter attributes, such as those returned by
    # the form helpers date_select, datetime_select, etc.
    # Also allows nested attributes, but this is not currently in use.
    include ActiveRecord::AttributeAssignment

    # For now, we overload the method to accept all attributes.
    # This is removed in Rails 5, so once we upgrade we can remove the overload.
    def sanitize_for_mass_assignment(attributes)
      return attributes
    end

    class << self
      # Delegates the list of attributes to the model, both readers and writers.
      # If the attribute value passed is a hash and not a symbol, assumes it is
      # a hash of one key, whose value is an array contained :reader, :writer, or both.
      # @example
      #   delegate_attributes :first_name, { last_name: [:reader] }
      # @param [Array<Symbol, Hash<Symbol, Array<Symbol>>>] attributes list of attributes to delegate to the model
      def delegate_attributes(*attributes)
        delegates = attributes.each_with_object([]) do |attribute, acc|
          case attribute
          when Hash
            key, value = attribute.first
            acc << key if value.include?(:reader)
            acc << "#{key}=" if value.include?(:writer)
          when Symbol, String
            acc.push(attribute, "#{attribute}=")
          else
            raise(ArgumentError, 'Attribute must be one of: Hash, Symbol, String')
          end
        end

        delegate(*delegates, to: :model)
      end

      # Delegates a specified associations to other another form object
      # @example
      #   delegate_associations :child, :parent, to: 'Forms::PersonForm'
      cattr_accessor(:associations) { {} }
      def delegate_association(association, to:)
        self.associations[association] = to

        # add a reader attribute
        class_eval <<~METHOD, __FILE__, __LINE__ + 1
          def #{association}
            return self.associated_forms['#{association}']
          end
        METHOD
      end
    end

    def associated_forms
      return @associated_forms ||= begin
        self.class.associations.map do |name, form_class_name|
          form_class = form_class_name.constantize
          form_class.new(@model.public_send(name))
        end
      end
    end

    # @!endgroup

    # @!group Validation

    validate :validate_model
    def validate_model
      unless @model.valid?
        @model.errors.each do |attribute, error|
          @errors.add(attribute, error)
        end
      end
    end
    protected :validate_model

    validate :validate_associated_forms
    def validate_associated_forms
      self.associated_forms.each do |_name, form|
        next if form.valid?
        form.errors.each do |_attribute, _error|
          @errors.add(:base, :association_error, "associated #{form.model_name.human} form has some errors")
        end
      end
    end
    protected :validate_associated_forms

    # @!endgroup

    # @!group Persistence

    def save
      saved = false
      @model.class.transaction do
        saved = @model.save
        self.associated_forms.each do |_name, form|
          saved &&= form.save
        end

        raise ActiveRecord::Rollback unless saved
      end

      return saved
    end

    def save!
      saved = false
      @model.class.transaction do
        saved = @model.save!
        self.associated_forms.each do |_name, form|
          saved &&= form.save! # no need to raise anything, save! will do so
        end
      end

      return saved
    end

    # @!endgroup
  end
end

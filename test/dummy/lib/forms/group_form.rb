module Forms
  class GroupForm < Kadmin::Form
    delegate_attributes :name, :owner_id
    delegate_association :owner, to: 'Forms::PersonForm'

    def initialize(*args)
      super
      raise(ArgumentError, 'Model given should be a group') unless @model.is_a?(Group)
    end

    def owner_attributes=(attributes)
      form = owner
      form.assign_attributes(attributes)
    end
  end
end

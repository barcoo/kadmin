module Forms
  class GroupForm < Kadmin::Form
    delegate_attributes :name, :owner_id

    def initialize(*args)
      super
      raise(ArgumentError, 'Model given should be a group') unless @model.is_a?(Group)
    end

    def owner
      owner = @model.owner || Person.new
      return Forms::PersonForm.new(owner)
    end

    def owner_attributes=(attributes)
      form = owner
      form.assign_attributes(attributes)
    end

    def model_valid?
      super

      if @model&.owner&.changed? && !@model.owner.valid?
        @errors.add(:base, :invalid, message: 'owner has invalid attributes')
      end
    end
  end
end

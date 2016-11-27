class GroupForm < Kadmin::Form
  delegate_attributes :name, owner_id: [:reader]
  delegate_association :owner, to: 'PersonForm'

  def initialize(*args)
    super
    raise(ArgumentError, 'Model given should be a group') unless @model.nil? || @model.is_a?(Group)
  end

  def owner_id=(id)
    @model.owner_id = id.to_i
  end

  def owner_attributes=(attributes)
    form = owner
    form.assign_attributes(attributes)
  end
end

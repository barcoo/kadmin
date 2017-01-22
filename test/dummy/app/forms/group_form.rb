class GroupForm < Kadmin::Form
  delegate_attributes :name, read_only: [:owner_id]
  delegate_association :owner, to: 'PersonForm'

  def owner_id=(id)
    @model.owner_id = id.to_i
  end

  def owner_attributes=(attributes)
    form = owner
    form.assign_attributes(attributes)
  end
end

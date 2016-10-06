class GroupPerson < ActiveRecord::Base
  belongs_to :group
  belongs_to :person

  validates :person_id, uniqueness: { scope: :group_id, message: 'can only be part once of the same group' }
end

class Group < ActiveRecord::Base
  has_many :group_people, dependent: :destroy, autosave: true
  has_many :people, through: :group_people
  belongs_to :owner, class_name: 'Person', required: false, validate: true

  validates :name, presence: true, length: { in: 1..254 },
                   format: { with: /[a-zA-Z0-9\-_\s]+/, message: 'only alphanumerics, dashes, underscores, and spaces' }
end

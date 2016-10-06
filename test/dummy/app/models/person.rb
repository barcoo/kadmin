class Person < ActiveRecord::Base
  has_many :relationships, autosave: true, dependent: :destroy, foreign_key: 'person_from'

  has_many :children, { autosave: true, dependent: :destroy, foreign_key: 'person_to' }, -> { where(name: 'child') }
  has_one :father, { autosave: true, dependent: :destroy, foreign_key: 'person_to' }, -> { where(name: 'father') }
end

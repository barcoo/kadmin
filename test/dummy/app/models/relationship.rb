class Relationship < ActiveRecord::Base
  belongs_to :from, autosave: true, class_name: Person.name, foreign_key: 'person_from'
  belongs_to :to, autosave: true, class_name: Person.name, foreign_key: 'person_to'
end

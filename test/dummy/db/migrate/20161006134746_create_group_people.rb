class CreateGroupPeople < ActiveRecord::Migration[4.2]
  def change
    create_table :group_people do |t|
      t.references :group
      t.references :person
      t.timestamps null: false

      t.index [:group_id, :person_id], unique: true, name: 'group_people_lookup'
    end
  end
end

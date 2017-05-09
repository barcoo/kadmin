class CreateGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id
      t.timestamps null: false

      t.index [:owner_id], name: 'groups_owner_lookup'
    end
  end
end

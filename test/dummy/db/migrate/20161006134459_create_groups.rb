class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id
      t.timestamps null: false

      t.index [:owner_id], name: 'groups_owner_lookup'
    end
  end
end

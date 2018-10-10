class CreateOrganizations < ActiveRecord::Migration[5.2]

  def change
    create_table :kadmin_organizations do |t|
      t.string :name
      t.timestamps
    end
    add_index :kadmin_organizations, :name, unique: true
  end
end

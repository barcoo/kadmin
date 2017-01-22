class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.index [:name], name: 'role_lookup', unique: true
    end
  end
end

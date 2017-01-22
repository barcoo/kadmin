class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender, limit: 1 # enum: m, f, o (other)
      t.date :date_of_birth
      t.integer :country_id, null: true

      t.timestamps
      t.index [:country_id], name: 'citizens'
    end
  end
end

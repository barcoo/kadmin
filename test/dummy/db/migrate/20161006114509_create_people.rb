class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :sex, limit: 1 # enum: m, f, o (other)
      t.date :date_of_birth
      t.timestamps null: false
    end
  end
end

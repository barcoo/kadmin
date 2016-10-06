class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.integer :sex, limit: 1 # enum: 0 => M, 1 => F, 2 => Undisclosed
      t.date :date_of_birth
      t.timestamps null: false
    end
  end
end

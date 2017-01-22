class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string :name, null: false
      t.binary :flag, null: false
      t.timestamps

      t.index [:name], name: 'country_lookup', unique: true
    end
  end
end

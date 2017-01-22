class CreateGenres < ActiveRecord::Migration[5.0]
  def change
    create_table :genres do |t|
      t.string :name, null: false
      t.index [:name], name: 'genre_lookup', unique: true
    end
  end
end

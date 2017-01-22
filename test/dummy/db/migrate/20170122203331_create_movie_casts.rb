class CreateMovieCasts < ActiveRecord::Migration[5.0]
  def change
    create_table :movie_casts do |t|
      t.integer :movie_id, null: false
      t.integer :person_id, null: false
      t.integer :role_id, null: false

      t.index [:movie_id, :person_id, :role_id], name: 'movie_cast_unicity', unique: true
      t.index [:person_id], name: 'person_movies'
      t.index [:role_id], name: 'role_distribution'
    end
  end
end

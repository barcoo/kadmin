class CreateMovieGenres < ActiveRecord::Migration[5.0]
  def change
    create_table :movie_genres do |t|
      t.integer :movie_id, null: false
      t.integer :genre_id, null: false

      t.index [:movie_id, :genre_id], name: 'movie_genre_unicity', unique: true
    end
  end
end

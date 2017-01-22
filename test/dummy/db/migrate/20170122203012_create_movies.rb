class CreateMovies < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
      t.text :title, null: false
      t.text :synopsis, null: true
      t.text :poster_url, null: true
      t.text :imdb_url, null: true
      t.date :release_date, null: false
      t.integer :country, null: false

      t.timestamps

      t.index [:title], name: 'movie_titles'
      t.index [:country_id], name: 'movies_per_country'
      t.index [:release_date], name: 'movies_released_on'
    end
  end
end

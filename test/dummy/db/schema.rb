# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170122210944) do

  create_table "countries", force: :cascade do |t|
    t.string   "name",       null: false
    t.binary   "flag",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "country_lookup", unique: true
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "genre_lookup", unique: true
  end

  create_table "movie_casts", force: :cascade do |t|
    t.integer "movie_id",  null: false
    t.integer "person_id", null: false
    t.integer "role_id",   null: false
    t.index ["movie_id", "person_id", "role_id"], name: "movie_cast_unicity", unique: true
    t.index ["person_id"], name: "person_movies"
    t.index ["role_id"], name: "role_distribution"
  end

  create_table "movie_genres", force: :cascade do |t|
    t.integer "movie_id", null: false
    t.integer "genre_id", null: false
    t.index ["movie_id", "genre_id"], name: "movie_genre_unicity", unique: true
  end

  create_table "movies", force: :cascade do |t|
    t.text     "title",        null: false
    t.text     "synopsis"
    t.text     "poster_url"
    t.text     "imdb_url"
    t.date     "release_date", null: false
    t.integer  "country",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["release_date"], name: "movies_released_on"
    t.index ["title"], name: "movie_titles"
    t.index [nil], name: "movies_per_country"
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender",        limit: 1
    t.date     "date_of_birth"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["country_id"], name: "citizens"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "role_lookup", unique: true
  end

end

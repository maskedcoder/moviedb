# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150127023507) do

  create_table "actors", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "movie_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "actors", ["movie_id"], :name => "index_actors_on_movie_id"

  create_table "actors_movies", :force => true do |t|
    t.integer "actor_id"
    t.integer "movie_id"
  end

  create_table "directors", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "directors_movies", :force => true do |t|
    t.integer "director_id"
    t.integer "movie_id"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "genres_movies", :force => true do |t|
    t.integer "genre_id"
    t.integer "movie_id"
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.integer  "dvd"
    t.date     "lastWatched"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "duration"
    t.integer  "year"
    t.string   "referenceNumber"
  end

  create_table "views", :force => true do |t|
    t.date     "when"
    t.integer  "movie_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "views", ["movie_id"], :name => "index_views_on_movie_id"

end

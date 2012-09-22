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

ActiveRecord::Schema.define(:version => 20120922123445) do

  create_table "games", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "tweet_id"
  end

  add_index "games", ["created_at"], :name => "index_games_on_created_at"
  add_index "games", ["updated_at"], :name => "index_games_on_updated_at"

  create_table "players", :force => true do |t|
    t.string   "name"
    t.integer  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "twitter"
  end

  add_index "players", ["created_at"], :name => "index_players_on_created_at"
  add_index "players", ["name"], :name => "index_players_on_name", :unique => true
  add_index "players", ["rating"], :name => "index_players_on_rating"
  add_index "players", ["updated_at"], :name => "index_players_on_updated_at"

  create_table "players_teams", :force => true do |t|
    t.integer "team_id"
    t.integer "player_id"
  end

  add_index "players_teams", ["player_id"], :name => "index_players_teams_on_player_id"
  add_index "players_teams", ["team_id"], :name => "index_players_teams_on_team_id"

  create_table "rating_histories", :force => true do |t|
    t.integer "game_id"
    t.integer "player_id"
    t.integer "rating"
  end

  add_index "rating_histories", ["game_id"], :name => "index_rating_histories_on_game_id"
  add_index "rating_histories", ["player_id"], :name => "index_rating_histories_on_player_id"

  create_table "teams", :force => true do |t|
    t.integer "game_id"
    t.integer "score"
    t.boolean "winners"
  end

  add_index "teams", ["game_id"], :name => "index_teams_on_game_id"
  add_index "teams", ["winners"], :name => "index_teams_on_winners"

end

# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 5) do

  create_table "friend_code_addeds", :force => true do |t|
    t.integer "user_id"
    t.integer "friend_code_id"
  end

  add_index "friend_code_addeds", ["user_id"], :name => "index_friend_code_addeds_on_user_id"
  add_index "friend_code_addeds", ["friend_code_id"], :name => "index_friend_code_addeds_on_friend_code_id"

  create_table "friend_codes", :force => true do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.string  "friend_code"
  end

  add_index "friend_codes", ["game_id"], :name => "index_friend_codes_on_game_id"
  add_index "friend_codes", ["user_id"], :name => "index_friend_codes_on_user_id"

  create_table "games", :force => true do |t|
    t.string "name"
    t.string "logo_url"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "users", :force => true do |t|
    t.string "friend_code"
  end

end

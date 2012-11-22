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

ActiveRecord::Schema.define(:version => 20121122044233) do

  create_table "events", :force => true do |t|
    t.string   "fb_id"
    t.text     "description"
    t.string   "end_time"
    t.boolean  "is_date_only"
    t.string   "location"
    t.string   "name"
    t.string   "owner_name"
    t.string   "owner_category"
    t.string   "owner_id"
    t.string   "privacy"
    t.string   "start_time"
    t.string   "timezone"
    t.string   "updated_time"
    t.string   "venue_id"
    t.float    "venue_latitude"
    t.float    "venue_longitude"
    t.string   "landmark_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "landmarks", :force => true do |t|
    t.string   "fb_id"
    t.string   "name"
    t.boolean  "is_published"
    t.string   "website"
    t.string   "username"
    t.text     "description"
    t.text     "about"
    t.string   "location_street"
    t.string   "location_city"
    t.string   "location_country"
    t.string   "location_zip"
    t.float    "location_latitude"
    t.float    "location_longitude"
    t.text     "public_transit"
    t.string   "phone"
    t.integer  "checkins"
    t.integer  "were_here_count"
    t.integer  "talking_about_count"
    t.string   "category"
    t.text     "general_info"
    t.string   "link"
    t.integer  "likes"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "slug"
  end

  add_index "landmarks", ["slug"], :name => "index_landmarks_on_slug", :unique => true

end

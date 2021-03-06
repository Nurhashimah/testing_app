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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180213040843) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.string   "eventname"
    t.string   "location"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "createdby"
    t.boolean  "is_public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repositories", force: true do |t|
    t.string   "title"
    t.integer  "staff_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uploaded_file_name"
    t.string   "uploaded_content_type"
    t.integer  "uploaded_file_size"
    t.datetime "uploaded_updated_at"
  end

end

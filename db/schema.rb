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

ActiveRecord::Schema.define(version: 20141209042633) do

  create_table "devices", force: true do |t|
    t.integer "user_id"
    t.string  "registration_id"
    t.string  "uuid"
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "event_relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_relationships", ["event_id"], name: "index_event_relationships_on_event_id", using: :btree
  add_index "event_relationships", ["user_id"], name: "index_event_relationships_on_user_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friend_relationships", force: true do |t|
    t.integer  "person_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friend_relationships", ["friend_id"], name: "index_friend_relationships_on_friend_id", using: :btree
  add_index "friend_relationships", ["person_id"], name: "index_friend_relationships_on_person_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "sender_id"
    t.integer  "event_id"
    t.integer  "recipient_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "participant_relationships", force: true do |t|
    t.integer  "event_id"
    t.integer  "participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participant_relationships", ["event_id"], name: "index_participant_relationships_on_event_id", using: :btree
  add_index "participant_relationships", ["participant_id"], name: "index_participant_relationships_on_participant_id", using: :btree

  create_table "statuses", force: true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.integer  "symbol_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["symbol_id"], name: "index_statuses_on_symbol_id", using: :btree
  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "user_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "fb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

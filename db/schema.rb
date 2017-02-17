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

ActiveRecord::Schema.define(version: 20170217014023) do

  create_table "devices", force: :cascade do |t|
    t.integer "user_id",         limit: 4
    t.string  "registration_id", limit: 191
    t.string  "uuid",            limit: 191
    t.string  "os",              limit: 191
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name",               limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id",      limit: 4
    t.text     "details",            limit: 65535
    t.string   "location",           limit: 191
    t.integer  "symbol_id",          limit: 4,                  null: false
    t.datetime "start_time"
    t.boolean  "public",             limit: 1
    t.integer  "category_id",        limit: 4
    t.string   "longitude",          limit: 191
    t.string   "latitude",           limit: 191
    t.string   "image_file_name",    limit: 191
    t.string   "image_content_type", limit: 191
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.string   "source",             limit: 191,   default: ""
    t.datetime "end_at"
    t.integer  "feed_id",            limit: 4
  end

  create_table "friend_group_memberships", force: :cascade do |t|
    t.integer  "friend_group_id", limit: 4
    t.integer  "member_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friend_group_memberships", ["friend_group_id"], name: "index_friend_group_memberships_on_friend_group_id", using: :btree
  add_index "friend_group_memberships", ["member_id"], name: "index_friend_group_memberships_on_member_id", using: :btree

  create_table "friend_groups", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 191
    t.boolean  "default",    limit: 1,   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "symbol_id",  limit: 4
  end

  add_index "friend_groups", ["user_id"], name: "index_friend_groups_on_user_id", using: :btree

  create_table "friend_relationships", force: :cascade do |t|
    t.integer  "person_id",  limit: 4
    t.integer  "friend_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friend_relationships", ["friend_id"], name: "index_friend_relationships_on_friend_id", using: :btree
  add_index "friend_relationships", ["person_id"], name: "index_friend_relationships_on_person_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id",          limit: 4
    t.integer  "event_id",           limit: 4
    t.string   "text",               limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "media",              limit: 191
    t.string   "source",             limit: 191
    t.string   "image_file_name",    limit: 191
    t.string   "image_content_type", limit: 191
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4,     null: false
    t.integer  "application_id",    limit: 4,     null: false
    t.string   "token",             limit: 191,   null: false
    t.integer  "expires_in",        limit: 4,     null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 191
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4
    t.integer  "application_id",    limit: 4
    t.string   "token",             limit: 191, null: false
    t.string   "refresh_token",     limit: 191
    t.integer  "expires_in",        limit: 4
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 191
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 191,   null: false
    t.string   "uid",          limit: 191,   null: false
    t.string   "secret",       limit: 191,   null: false
    t.text     "redirect_uri", limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "participant_relationships", force: :cascade do |t|
    t.integer  "event_id",       limit: 4
    t.integer  "participant_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "notify",         limit: 1, default: true
  end

  add_index "participant_relationships", ["event_id"], name: "index_participant_relationships_on_event_id", using: :btree
  add_index "participant_relationships", ["participant_id"], name: "index_participant_relationships_on_participant_id", using: :btree

  create_table "shouts", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.string   "text",               limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",           limit: 4
    t.string   "image_file_name",    limit: 191
    t.string   "image_content_type", limit: 191
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.string   "source",             limit: 191,   default: ""
    t.text     "url",                limit: 65535
    t.integer  "flag",               limit: 4
    t.integer  "ups",                limit: 4
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "text",       limit: 191
    t.integer  "user_id",    limit: 4
    t.integer  "symbol_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ups",        limit: 4
  end

  add_index "statuses", ["symbol_id"], name: "index_statuses_on_symbol_id", using: :btree
  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id", using: :btree

  create_table "symbols", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uppings", force: :cascade do |t|
    t.integer  "status_id",   limit: 4
    t.integer  "upped_by_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uppings", ["status_id"], name: "index_uppings_on_status_id", using: :btree
  add_index "uppings", ["upped_by_id"], name: "index_uppings_on_upped_by_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "user_name",          limit: 191
    t.string   "first_name",         limit: 191
    t.string   "last_name",          limit: 191
    t.string   "email",              limit: 191
    t.string   "fb_id",              limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",               limit: 191
    t.string   "latitude",           limit: 191
    t.string   "longitude",          limit: 191
    t.string   "image_file_name",    limit: 191
    t.string   "image_content_type", limit: 191
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.string   "source",             limit: 191, default: ""
    t.boolean  "accepted_terms",     limit: 1
  end

end

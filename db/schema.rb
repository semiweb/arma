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

ActiveRecord::Schema.define(version: 20160125164526) do

  create_table "applications", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "arma_code_changelog_entries", force: true do |t|
    t.string   "filename"
    t.string   "directory"
    t.datetime "committed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "installations", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "env"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_changelog_count", default: true
    t.text     "notes"
  end

  add_index "installations", ["application_id"], name: "index_installations_on_application_id"
  add_index "installations", ["name", "location", "env"], name: "index_installations_on_name_and_location_and_env"

  create_table "states", force: true do |t|
    t.string   "ref"
    t.string   "branch"
    t.text     "diff"
    t.integer  "local_commits"
    t.string   "github_repo"
    t.datetime "commit_date"
    t.integer  "installation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message"
  end

  add_index "states", ["installation_id"], name: "index_states_on_installation_id"

  create_table "users", force: true do |t|
    t.string   "username",            default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end

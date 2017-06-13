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

ActiveRecord::Schema.define(version: 20170606142610) do

  create_table "applications", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "github_repo"
  end

  create_table "branch_watchers", force: true do |t|
    t.integer  "application_id"
    t.string   "branch_name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.integer  "application_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_changelogs", force: true do |t|
    t.integer "category_id"
    t.integer "changelog_id"
  end

  create_table "changelog_reports", force: true do |t|
    t.integer  "installation_id"
    t.integer  "application_id"
    t.text     "content"
    t.string   "name"
    t.datetime "sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "changelog_reports_changelogs", force: true do |t|
    t.integer "changelog_id"
    t.integer "changelog_report_id"
  end

  create_table "changelogs", force: true do |t|
    t.integer  "commit_id"
    t.string   "keyword"
    t.string   "affected"
    t.text     "content"
    t.boolean  "ignored",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commits", force: true do |t|
    t.datetime "commit_time"
    t.string   "ref"
    t.string   "branch"
    t.integer  "application_id"
    t.string   "author"
    t.boolean  "downtime"
    t.text     "full_commit_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commits", ["ref"], name: "index_commits_on_ref", unique: true

  create_table "installations", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "env"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_changelog_count", default: true
    t.text     "notes"
    t.boolean  "server_status",        default: false
    t.datetime "last_monitor_check"
    t.boolean  "changelog",            default: false
    t.boolean  "server_monitor",       default: false
    t.boolean  "login_check",          default: false
    t.string   "affected",             default: ""
    t.string   "host",                 default: ""
  end

  add_index "installations", ["application_id"], name: "index_installations_on_application_id"
  add_index "installations", ["name", "location", "env"], name: "index_installations_on_name_and_location_and_env"

  create_table "server_monitors", force: true do |t|
    t.integer  "installation_id"
    t.string   "status"
    t.datetime "time_start"
    t.datetime "time_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  add_index "states", ["created_at"], name: "index_states_on_created_at"
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

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

ActiveRecord::Schema.define(version: 20160311022916) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "categories_ideas", id: false, force: true do |t|
    t.integer "category_id", null: false
    t.integer "idea_id",     null: false
  end

  add_index "categories_ideas", ["idea_id", "category_id"], name: "index_categories_ideas_on_idea_id_and_category_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "idea_links", force: true do |t|
    t.string   "name"
    t.string   "link_url"
    t.integer  "user_id"
    t.string   "slug"
    t.integer  "idea_linkable_id"
    t.string   "idea_linkable_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "idea_links", ["idea_linkable_id", "idea_linkable_type"], name: "index_idea_links_on_idea_linkable_id_and_idea_linkable_type", using: :btree
  add_index "idea_links", ["user_id"], name: "index_idea_links_on_user_id", using: :btree

  create_table "ideas", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "benefits"
    t.text     "problem_solves"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "status"
  end

  add_index "ideas", ["user_id"], name: "index_ideas_on_user_id", using: :btree

  create_table "jots", force: true do |t|
    t.text     "context"
    t.integer  "user_id"
    t.integer  "position"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "jots", ["user_id"], name: "index_jots_on_user_id", using: :btree

  create_table "notes", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.string   "slug"
    t.integer  "user_id"
    t.integer  "notable_id"
    t.string   "notable_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "notes", ["notable_id", "notable_type"], name: "index_notes_on_notable_id_and_notable_type", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "assigned_by"
    t.integer  "assigned_to"
    t.integer  "user_id"
    t.integer  "percent_complete"
    t.date     "start_date"
    t.date     "finish_date"
    t.date     "completion_date"
    t.string   "status"
    t.string   "slug"
    t.integer  "taskable_id"
    t.string   "taskable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "position"
  end

  add_index "tasks", ["taskable_id", "taskable_type"], name: "index_tasks_on_taskable_id_and_taskable_type", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "slug"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

end

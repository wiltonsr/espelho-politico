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

ActiveRecord::Schema.define(version: 20141004215244) do

  create_table "parliamentarians", force: true do |t|
    t.string  "registry"
    t.string  "condition"
    t.string  "name"
    t.string  "url_photo"
    t.string  "state"
    t.string  "party"
    t.string  "phone"
    t.string  "email"
    t.integer "cabinet"
  end

  add_index "parliamentarians", ["name"], name: "index_parliamentarians_on_name", using: :btree
  add_index "parliamentarians", ["registry"], name: "index_parliamentarians_on_registry", using: :btree

  create_table "parliamentarians_propositions", id: false, force: true do |t|
    t.integer "parliamentarian_id", null: false
    t.integer "proposition_id",     null: false
  end

  add_index "parliamentarians_propositions", ["parliamentarian_id"], name: "index_parliamentarians_propositions_on_parliamentarian_id", using: :btree
  add_index "parliamentarians_propositions", ["proposition_id"], name: "index_parliamentarians_propositions_on_proposition_id", using: :btree

  create_table "proposition_types", force: true do |t|
    t.string "acronym"
    t.string "description"
  end

  create_table "propositions", force: true do |t|
    t.integer "year"
    t.integer "number"
    t.text    "amendment"
    t.text    "explanation"
    t.integer "proposition_types_id"
    t.date    "presentation_date"
    t.string  "situation"
    t.string  "content_link"
  end

  add_index "propositions", ["number", "year"], name: "index_propositions_on_number_and_year", unique: true, using: :btree

  create_table "propositions_themes", id: false, force: true do |t|
    t.integer "proposition_id", null: false
    t.integer "theme_id",       null: false
  end

  add_index "propositions_themes", ["proposition_id"], name: "index_propositions_themes_on_proposition_id", using: :btree
  add_index "propositions_themes", ["theme_id"], name: "index_propositions_themes_on_theme_id", using: :btree

  create_table "themes", force: true do |t|
    t.string "description"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end

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

ActiveRecord::Schema.define(version: 20141101061856) do

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

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

  create_table "propositions", force: true do |t|
    t.integer "year"
    t.integer "number"
    t.text    "amendment"
    t.text    "explanation"
    t.string  "proposition_types"
    t.date    "presentation_date"
    t.string  "situation"
    t.string  "content_link"
    t.integer "parliamentarian_id"
  end

  add_index "propositions", ["number", "year", "proposition_types"], name: "index_propositions_on_number_and_year_and_proposition_types", unique: true, using: :btree

  create_table "propositions_themes", id: false, force: true do |t|
    t.integer "proposition_id", null: false
    t.integer "theme_id",       null: false
  end

  add_index "propositions_themes", ["proposition_id", "theme_id"], name: "index_propositions_themes_on_proposition_id_and_theme_id", unique: true, using: :btree
  add_index "propositions_themes", ["proposition_id"], name: "index_propositions_themes_on_proposition_id", using: :btree
  add_index "propositions_themes", ["theme_id"], name: "index_propositions_themes_on_theme_id", using: :btree

  create_table "themes", force: true do |t|
    t.string "description"
  end

  add_index "themes", ["description"], name: "index_themes_on_description", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                  default: false
    t.string   "activation_digest"
    t.boolean  "activated",              default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end

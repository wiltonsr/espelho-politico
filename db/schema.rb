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

ActiveRecord::Schema.define(version: 20140920204051) do

  create_table "parlamentar", force: true do |t|
    t.string  "matricula"
    t.string  "condicao"
    t.string  "nome"
    t.string  "url_foto"
    t.string  "uf"
    t.string  "partido"
    t.string  "telefone"
    t.string  "email"
    t.integer "gabinete"
  end

  create_table "proposicao", force: true do |t|
    t.integer "ano"
    t.integer "numero"
    t.text    "ementa"
    t.text    "explicacao"
    t.string  "tema"
    t.integer "parlamentar_id"
    t.date    "data_apresentacao"
    t.string  "situacao"
    t.string  "link_teor"
  end

end

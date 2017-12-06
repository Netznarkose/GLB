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

ActiveRecord::Schema.define(version: 20171206081739) do

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "comment"
  end

  create_table "entries", force: :cascade do |t|
    t.string   "namenskuerzel",                           limit: 255
    t.string   "kennzahl",                                limit: 255
    t.string   "spaltenzahl",                             limit: 255
    t.string   "japanische_umschrift",                    limit: 255
    t.string   "kanji",                                   limit: 255
    t.string   "pali",                                    limit: 255
    t.string   "sanskrit",                                limit: 255
    t.string   "chinesisch",                              limit: 255
    t.string   "tibetisch",                               limit: 255
    t.string   "koreanisch",                              limit: 255
    t.string   "weitere_sprachen",                        limit: 255
    t.string   "alternative_japanische_lesungen",         limit: 255
    t.string   "schreibvarianten",                        limit: 255
    t.string   "deutsche_uebersetzung",                   limit: 255
    t.string   "lemma_art",                               limit: 255
    t.string   "jahreszahlen",                            limit: 255
    t.text     "uebersetzung"
    t.text     "quellen"
    t.text     "literatur"
    t.text     "eigene_ergaenzungen"
    t.text     "quellen_ergaenzungen"
    t.text     "literatur_ergaenzungen"
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
    t.integer  "user_id"
    t.string   "page_reference",                          limit: 255
    t.boolean  "freigeschaltet",                                      default: false
    t.string   "romaji_order",                            limit: 255
    t.string   "japanische_umschrift_din"
    t.string   "lemma_in_katakana"
    t.string   "lemma_in_lateinbuchstaben"
    t.string   "abweichende_kennzahl"
    t.string   "japanischer_quelltext"
    t.string   "japanischer_quelltext_bearbeitungsstand"
    t.string   "seite_textblock2005"
    t.string   "bearbeitungsstand",                                   default: "unbearbeitet"
    t.string   "bearbeitungsansatz"
  end

  create_table "entry_docs", force: :cascade do |t|
    t.string   "namenskuerzel",                   limit: 255
    t.string   "kennzahl",                        limit: 255
    t.string   "spaltenzahl",                     limit: 255
    t.string   "japanische_umschrift",            limit: 255
    t.string   "kanji",                           limit: 255
    t.string   "pali",                            limit: 255
    t.string   "sanskrit",                        limit: 255
    t.string   "chinesisch",                      limit: 255
    t.string   "tibetisch",                       limit: 255
    t.string   "koreanisch",                      limit: 255
    t.string   "weitere_sprachen",                limit: 255
    t.string   "alternative_japanische_lesungen", limit: 255
    t.string   "schreibvarianten",                limit: 255
    t.string   "deutsche_uebersetzung",           limit: 255
    t.string   "lemma_art",                       limit: 255
    t.string   "jahreszahlen",                    limit: 255
    t.text     "uebersetzung"
    t.text     "quellen"
    t.text     "literatur"
    t.text     "eigene_ergaenzungen"
    t.text     "quellen_ergaenzungen"
    t.text     "literatur_ergaenzungen"
    t.integer  "entry_id"
    t.string   "romaji_order",                    limit: 255
    t.string   "page_reference",                  limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "entry_htmls", force: :cascade do |t|
    t.string   "namenskuerzel",                   limit: 255
    t.string   "kennzahl",                        limit: 255
    t.string   "spaltenzahl",                     limit: 255
    t.string   "japanische_umschrift",            limit: 255
    t.string   "kanji",                           limit: 255
    t.string   "pali",                            limit: 255
    t.string   "sanskrit",                        limit: 255
    t.string   "chinesisch",                      limit: 255
    t.string   "tibetisch",                       limit: 255
    t.string   "koreanisch",                      limit: 255
    t.string   "weitere_sprachen",                limit: 255
    t.string   "alternative_japanische_lesungen", limit: 255
    t.string   "schreibvarianten",                limit: 255
    t.string   "deutsche_uebersetzung",           limit: 255
    t.string   "lemma_art",                       limit: 255
    t.string   "jahreszahlen",                    limit: 255
    t.text     "uebersetzung"
    t.integer  "entry_id"
    t.string   "romaji_order",                    limit: 255
    t.string   "page_reference",                  limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
    t.string   "role",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255, null: false
    t.integer  "item_id",                null: false
    t.string   "event",      limit: 255, null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end

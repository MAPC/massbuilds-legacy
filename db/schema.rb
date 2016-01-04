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

ActiveRecord::Schema.define(version: 20160104162316) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "broadcasts", force: :cascade do |t|
    t.string   "subject"
    t.string   "body"
    t.string   "scope"
    t.datetime "scheduled_for"
    t.string   "state"
    t.integer  "creator_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "broadcasts", ["creator_id"], name: "index_broadcasts_on_creator_id", using: :btree

  create_table "claims", force: :cascade do |t|
    t.integer  "claimant_id"
    t.integer  "development_id"
    t.integer  "moderator_id"
    t.string   "role"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "reason"
    t.string   "state"
  end

  add_index "claims", ["claimant_id"], name: "index_claims_on_claimant_id", using: :btree
  add_index "claims", ["development_id"], name: "index_claims_on_development_id", using: :btree
  add_index "claims", ["moderator_id"], name: "index_claims_on_moderator_id", using: :btree

  create_table "crosswalks", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "development_id"
    t.string   "internal_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "crosswalks", ["development_id"], name: "index_crosswalks_on_development_id", using: :btree
  add_index "crosswalks", ["organization_id"], name: "index_crosswalks_on_organization_id", using: :btree

  create_table "development_team_memberships", force: :cascade do |t|
    t.string   "role"
    t.integer  "development_id"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "development_team_memberships", ["development_id"], name: "index_development_team_memberships_on_development_id", using: :btree
  add_index "development_team_memberships", ["organization_id"], name: "index_development_team_memberships_on_organization_id", using: :btree

  create_table "developments", force: :cascade do |t|
    t.integer  "creator_id"
    t.json     "fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "developments", ["creator_id"], name: "index_developments_on_creator_id", using: :btree

  create_table "developments_programs", force: :cascade do |t|
    t.integer "development_id"
    t.integer "program_id"
  end

  add_index "developments_programs", ["development_id"], name: "index_developments_programs_on_development_id", using: :btree
  add_index "developments_programs", ["program_id"], name: "index_developments_programs_on_program_id", using: :btree

  create_table "edits", force: :cascade do |t|
    t.integer  "editor_id"
    t.integer  "moderator_id"
    t.integer  "development_id"
    t.string   "state"
    t.json     "fields"
    t.datetime "applied_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "ignore_conflicts", default: false
    t.datetime "moderated_at"
  end

  add_index "edits", ["development_id"], name: "index_edits_on_development_id", using: :btree
  add_index "edits", ["editor_id"], name: "index_edits_on_editor_id", using: :btree
  add_index "edits", ["moderator_id"], name: "index_edits_on_moderator_id", using: :btree

  create_table "field_edits", force: :cascade do |t|
    t.integer  "edit_id"
    t.string   "name"
    t.json     "change"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "field_edits", ["edit_id"], name: "index_field_edits_on_edit_id", using: :btree

  create_table "flags", force: :cascade do |t|
    t.integer  "flagger_id"
    t.integer  "development_id"
    t.text     "reason"
    t.string   "state"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "resolver_id"
  end

  add_index "flags", ["development_id"], name: "index_flags_on_development_id", using: :btree
  add_index "flags", ["flagger_id"], name: "index_flags_on_flagger_id", using: :btree

  create_table "inbox_notices", force: :cascade do |t|
    t.string   "subject"
    t.string   "body"
    t.string   "state"
    t.string   "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "state"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "memberships", ["organization_id"], name: "index_memberships_on_organization_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.string   "website"
    t.string   "url_template"
    t.string   "location"
    t.string   "email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "abbv"
    t.string   "short_name"
    t.boolean  "type"
  end

  add_index "organizations", ["creator_id"], name: "index_organizations_on_creator_id", using: :btree

  create_table "place_profiles", force: :cascade do |t|
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.decimal  "radius"
    t.json     "polygon"
    t.json     "response"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.integer  "sort_order"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "hashed_email"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "verifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "verifier_id"
    t.text     "reason"
    t.string   "state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "verifications", ["user_id"], name: "index_verifications_on_user_id", using: :btree
  add_index "verifications", ["verifier_id"], name: "index_verifications_on_verifier_id", using: :btree

  add_foreign_key "claims", "developments"
  add_foreign_key "crosswalks", "developments"
  add_foreign_key "crosswalks", "organizations"
  add_foreign_key "development_team_memberships", "developments"
  add_foreign_key "development_team_memberships", "organizations"
  add_foreign_key "developments_programs", "developments"
  add_foreign_key "developments_programs", "programs"
  add_foreign_key "edits", "developments"
  add_foreign_key "field_edits", "edits"
  add_foreign_key "flags", "developments"
  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "verifications", "users"
end

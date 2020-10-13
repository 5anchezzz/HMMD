# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_13_095841) do

  create_table "clients", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "phone"
    t.date "birthday"
    t.string "sex"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
    t.boolean "blocked"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "visit_id", null: false
    t.string "label"
    t.text "description"
    t.string "state"
    t.integer "days_to_show"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "show_date"
    t.index ["user_id"], name: "index_reminders_on_user_id"
    t.index ["visit_id"], name: "index_reminders_on_visit_id"
  end

  create_table "slots", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "visit_id", null: false
    t.date "date"
    t.integer "number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_slots_on_user_id"
    t.index ["visit_id"], name: "index_slots_on_visit_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "surname"
    t.date "birthday"
    t.string "sex"
    t.string "country"
    t.string "city"
    t.string "phone"
    t.string "organization_name"
    t.string "organization_address"
    t.string "field_of_activity"
    t.integer "start_hour"
    t.integer "end_hour"
    t.boolean "holiday"
    t.integer "slot_size"
    t.string "state"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "client_id", null: false
    t.string "label"
    t.string "description"
    t.date "date"
    t.time "start"
    t.float "duration"
    t.integer "value"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "late"
    t.boolean "negative"
    t.boolean "interval"
    t.index ["client_id"], name: "index_visits_on_client_id"
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  add_foreign_key "clients", "users"
  add_foreign_key "reminders", "users"
  add_foreign_key "reminders", "visits"
  add_foreign_key "slots", "users"
  add_foreign_key "slots", "visits"
  add_foreign_key "visits", "clients"
  add_foreign_key "visits", "users"
end

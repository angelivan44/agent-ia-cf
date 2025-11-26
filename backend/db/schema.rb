# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_26_133804) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "insurance_requests", force: :cascade do |t|
    t.string "email"
    t.string "full_name"
    t.string "national_id"
    t.string "vehicle_plate_number"
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "vehicle_id"
    t.index ["email"], name: "index_insurance_requests_on_email", unique: true
    t.index ["national_id"], name: "index_insurance_requests_on_national_id", unique: true
    t.index ["user_id"], name: "index_insurance_requests_on_user_id"
    t.index ["vehicle_id"], name: "index_insurance_requests_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "last_name"
    t.date "birth_date"
    t.string "national_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["national_id"], name: "index_users_on_national_id", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "plate_number"
    t.date "year"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plate_number"], name: "index_vehicles_on_plate_number", unique: true
    t.index ["user_id"], name: "index_vehicles_on_user_id"
  end

  create_table "violations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "national_id"
    t.integer "infractions"
  end

  add_foreign_key "insurance_requests", "users", on_delete: :nullify
  add_foreign_key "insurance_requests", "vehicles", on_delete: :nullify
  add_foreign_key "vehicles", "users"
end

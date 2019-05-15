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

ActiveRecord::Schema.define(version: 2019_05_15_141049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "choices", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "food_id"
    t.float "amount"
    t.string "measure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_choices_on_food_id"
    t.index ["user_id"], name: "index_choices_on_user_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name"
    t.integer "serving_grams"
    t.string "serving_unit_name"
    t.float "serving_unit_amount"
    t.string "brand"
    t.float "calories"
    t.float "fat"
    t.float "carbs"
    t.float "protein"
    t.float "cholesterol"
    t.float "dietary_fiber"
    t.float "potassium"
    t.float "saturated_fat"
    t.float "sodium"
    t.float "sugars"
    t.string "unit_size"
    t.bigint "upc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "choices", "foods"
  add_foreign_key "choices", "users"
end

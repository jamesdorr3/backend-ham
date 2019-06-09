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

ActiveRecord::Schema.define(version: 2019_06_08_181939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.bigint "index"
    t.boolean "repeat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "choices", force: :cascade do |t|
    t.bigint "food_id"
    t.bigint "day_id"
    t.float "amount"
    t.bigint "category_id"
    t.integer "index"
    t.bigint "measure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_choices_on_category_id"
    t.index ["day_id"], name: "index_choices_on_day_id"
    t.index ["food_id"], name: "index_choices_on_food_id"
  end

  create_table "days", force: :cascade do |t|
    t.string "name"
    t.bigint "goal_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_days_on_goal_id"
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
    t.string "upc"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_foods_on_user_id"
  end

  create_table "goals", force: :cascade do |t|
    t.bigint "user_id"
    t.float "calories"
    t.float "fat"
    t.float "carbs"
    t.float "protein"
    t.string "name"
    t.boolean "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "measures", force: :cascade do |t|
    t.bigint "food_id"
    t.float "amount"
    t.float "grams"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_measures_on_food_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "categories", "users"
  add_foreign_key "choices", "categories"
  add_foreign_key "choices", "days"
  add_foreign_key "choices", "foods"
  add_foreign_key "days", "goals"
  add_foreign_key "foods", "users"
  add_foreign_key "goals", "users"
  add_foreign_key "measures", "foods"
end

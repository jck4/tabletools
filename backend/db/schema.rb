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

ActiveRecord::Schema[8.0].define(version: 2025_02_20_135020) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "encounters", force: :cascade do |t|
    t.string "title"
    t.text "setting"
    t.jsonb "factions"
    t.jsonb "clues"
    t.jsonb "objectives"
    t.jsonb "environmental_hazards"
    t.jsonb "reactive_elements"
    t.jsonb "outcomes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "npcs", force: :cascade do |t|
    t.string "name"
    t.string "race"
    t.string "occupation"
    t.text "background"
    t.jsonb "personality_traits"
    t.jsonb "quirks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quests", force: :cascade do |t|
    t.string "title"
    t.text "setting"
    t.text "hook"
    t.jsonb "complications"
    t.jsonb "potential_outcomes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traps", force: :cascade do |t|
    t.string "name"
    t.text "location"
    t.string "trap_type"
    t.text "trigger"
    t.text "mechanism"
    t.jsonb "effects"
    t.string "disarm_check"
    t.integer "disarm_difficulty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "treasures", force: :cascade do |t|
    t.string "name"
    t.string "treasure_type"
    t.string "rarity"
    t.text "description"
    t.jsonb "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end

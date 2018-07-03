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

ActiveRecord::Schema.define(version: 2018_07_03_162830) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "apartment_movements", force: :cascade do |t|
    t.integer "apartment_id"
    t.integer "movement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movement_id"], name: "index_apartment_movements_on_movement_id", unique: true
  end

  create_table "apartment_pending_payments", force: :cascade do |t|
    t.integer "apartment_id"
    t.integer "pending_payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pending_payment_id"], name: "index_apartment_pending_payments_on_pending_payment_id", unique: true
  end

  create_table "apartments", force: :cascade do |t|
    t.string "owner"
    t.integer "floor"
    t.string "letter"
    t.float "fee"
    t.float "balance", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "apartment_contribution"
    t.index ["floor", "letter"], name: "index_apartments_on_floor_and_letter", unique: true
  end

  create_table "movements", force: :cascade do |t|
    t.text "concept"
    t.date "date"
    t.float "amount"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_value"
    t.string "currency_movement"
    t.float "post_balance"
    t.string "currency_balance"
    t.integer "office"
    t.string "concept1"
    t.string "concept2"
    t.string "concept3"
    t.string "concept4"
    t.string "concept5"
    t.string "concept6"
    t.string "movement_digest"
  end

  create_table "pending_payments", force: :cascade do |t|
    t.text "concept"
    t.date "date"
    t.integer "amount"
    t.text "description"
    t.boolean "paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statement_movements", force: :cascade do |t|
    t.integer "statement_id"
    t.integer "movement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statement_id", "movement_id"], name: "index_statement_movements_on_statement_id_and_movement_id", unique: true
  end

  create_table "statements", force: :cascade do |t|
    t.text "name"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_apartments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "apartment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "apartment_id"], name: "index_user_apartments_on_user_id_and_apartment_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birthday"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

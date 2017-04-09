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

ActiveRecord::Schema.define(version: 20170408101716) do

  create_table "answers", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "comment"
    t.integer  "points"
    t.string   "attachment"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "homework_id"
    t.integer  "user_id"
    t.string   "download_link"
  end

  create_table "attendances", force: :cascade do |t|
    t.string   "district"
    t.string   "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "dictionaries", force: :cascade do |t|
    t.string   "confirm_code"
    t.string   "password"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "discussions", force: :cascade do |t|
    t.string   "title"
    t.string   "email"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "homework_users", force: :cascade do |t|
    t.integer  "homework_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "homeworks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
    t.datetime "deadline"
    t.string   "attachment"
    t.string   "download_link"
    t.string   "district"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "description"
    t.integer  "discussion_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string   "date"
    t.string   "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "read"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "answer_id"
    t.integer  "point"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "confirm_code"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "user_attendances", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "attendance_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "attendance_id"
    t.string   "note"
    t.integer  "description"
    t.datetime "arrive_at"
  end

  create_table "user_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                               null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "district"
    t.integer  "role"
    t.string   "confirm_code"
    t.integer  "area"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

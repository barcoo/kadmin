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

ActiveRecord::Schema.define(version: 20160728145414) do

  create_table "postman_web_inbox_messages", force: :cascade do |t|
    t.string   "header"
    t.text     "message"
    t.string   "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "postman_web_jobs", force: :cascade do |t|
    t.string   "name",                         null: false
    t.string   "subscribers",     default: ""
    t.string   "recipients_type",              null: false
    t.text     "recipients",                   null: false
    t.integer  "notification_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "postman_web_jobs", ["name"], name: "index_postman_web_jobs_on_name", unique: true
  add_index "postman_web_jobs", ["notification_id"], name: "index_postman_web_jobs_on_notification_id"

  create_table "postman_web_notifications", force: :cascade do |t|
    t.string   "text_id",                          null: false
    t.text     "url",                              null: false
    t.integer  "push_message_id"
    t.integer  "inbox_message_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "manual",           default: false
  end

  add_index "postman_web_notifications", ["created_at", "updated_at"], name: "index_postman_web_notifications_on_created_at_and_updated_at"
  add_index "postman_web_notifications", ["manual"], name: "index_postman_web_notifications_on_manual"
  add_index "postman_web_notifications", ["text_id"], name: "index_postman_web_notifications_on_text_id"

  create_table "postman_web_push_messages", force: :cascade do |t|
    t.string   "header"
    t.text     "message"
    t.string   "action"
    t.string   "icon_url"
    t.string   "big_picture_url"
    t.integer  "badge"
    t.string   "category"
    t.text     "data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "postman_web_runs", force: :cascade do |t|
    t.string   "name",         default: ""
    t.string   "created_by"
    t.string   "flow_id",      default: ""
    t.datetime "created_at",                null: false
    t.datetime "scheduled_at"
    t.integer  "job_id"
    t.integer  "status",       default: 0
    t.text     "summary"
  end

  add_index "postman_web_runs", ["created_at"], name: "index_postman_web_runs_on_created_at"
  add_index "postman_web_runs", ["job_id"], name: "index_postman_web_runs_on_job_id"

end

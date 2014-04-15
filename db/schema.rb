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

ActiveRecord::Schema.define(version: 20140403052356) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "username",   null: false
    t.text     "bio"
    t.string   "avatar"
    t.integer  "role"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", unique: true, using: :btree
  add_index "accounts", ["username"], name: "index_accounts_on_username", unique: true, using: :btree

  create_table "answers", force: true do |t|
    t.text     "content",     null: false
    t.integer  "account_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["account_id"], name: "index_answers_on_account_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "display_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "content",          null: false
    t.integer  "account_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["account_id"], name: "index_comments_on_account_id", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "account_id"
    t.integer  "group_id"
    t.boolean  "admin",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["account_id"], name: "index_memberships_on_account_id", using: :btree
  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree

  create_table "priorities", force: true do |t|
    t.string   "name"
    t.integer  "display_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_tags", force: true do |t|
    t.integer  "question_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_tags", ["question_id"], name: "index_question_tags_on_question_id", using: :btree
  add_index "question_tags", ["tag_id"], name: "index_question_tags_on_tag_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "title",                             null: false
    t.text     "content",                           null: false
    t.boolean  "public",             default: true
    t.integer  "account_id"
    t.integer  "group_id"
    t.integer  "accepted_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["accepted_answer_id"], name: "index_questions_on_accepted_answer_id", using: :btree
  add_index "questions", ["account_id"], name: "index_questions_on_account_id", using: :btree
  add_index "questions", ["group_id"], name: "index_questions_on_group_id", using: :btree

  create_table "statuses", force: true do |t|
    t.string   "name"
    t.integer  "display_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: true do |t|
    t.string   "subject",     null: false
    t.text     "content",     null: false
    t.integer  "account_id"
    t.integer  "assignee_id"
    t.integer  "category_id"
    t.integer  "status_id"
    t.integer  "priority_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tickets", ["account_id"], name: "index_tickets_on_account_id", using: :btree
  add_index "tickets", ["assignee_id"], name: "index_tickets_on_assignee_id", using: :btree
  add_index "tickets", ["category_id"], name: "index_tickets_on_category_id", using: :btree
  add_index "tickets", ["priority_id"], name: "index_tickets_on_priority_id", using: :btree
  add_index "tickets", ["status_id"], name: "index_tickets_on_status_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",                       null: false
    t.string   "last_name",                        null: false
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end

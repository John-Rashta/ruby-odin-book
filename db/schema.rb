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

ActiveRecord::Schema[8.1].define(version: 2026_03_17_155632) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "comment_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.bigint "creator_id", null: false
    t.bigint "post_id", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comments_on_comment_id"
    t.index ["creator_id"], name: "index_comments_on_creator_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "followships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "follower_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["follower_id"], name: "index_followships_on_follower_id"
    t.index ["user_id", "follower_id"], name: "index_followships_on_user_id_and_follower_id", unique: true
    t.index ["user_id"], name: "index_followships_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "contentable_id"
    t.string "contentable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["contentable_id", "contentable_type", "user_id"], name: "index_likes_on_contentable_id_and_contentable_type_and_user_id", unique: true
    t.index ["contentable_type", "contentable_id"], name: "index_likes_on_contentable"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "creator_id", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_posts_on_creator_id"
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "sender_id", null: false
    t.integer "table_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["sender_id"], name: "index_requests_on_sender_id"
    t.index ["user_id", "sender_id", "table_type"], name: "index_requests_on_user_id_and_sender_id_and_table_type", unique: true
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "comments", "comments"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users", column: "creator_id"
  add_foreign_key "followships", "users"
  add_foreign_key "followships", "users", column: "follower_id"
  add_foreign_key "posts", "users", column: "creator_id"
  add_foreign_key "requests", "users"
  add_foreign_key "requests", "users", column: "sender_id"
end

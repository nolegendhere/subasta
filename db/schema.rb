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

ActiveRecord::Schema.define(version: 20140910152812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auctions", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auctions", ["user_id", "created_at"], name: "index_auctions_on_user_id_and_created_at", using: :btree

  create_table "bids", force: true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "subcategory"
    t.integer  "price"
    t.integer  "user_id"
    t.integer  "auction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_amount",       default: 0
    t.integer  "actual_amount",    default: 0
    t.integer  "actual_amount_id"
  end

  add_index "bids", ["auction_id"], name: "index_bids_on_auction_id", using: :btree
  add_index "bids", ["user_id", "created_at"], name: "index_bids_on_user_id_and_created_at", using: :btree

  create_table "choices", force: true do |t|
    t.boolean  "pg",         default: false
    t.boolean  "sg",         default: false
    t.boolean  "sf",         default: false
    t.boolean  "pf",         default: false
    t.boolean  "ce",         default: false
    t.boolean  "player",     default: false
    t.boolean  "team",       default: false
    t.boolean  "max_amount", default: false
    t.boolean  "min_amount", default: false
    t.boolean  "max_time",   default: false
    t.boolean  "min_time",   default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "choices", ["user_id"], name: "index_choices_on_user_id", using: :btree

  create_table "investments", force: true do |t|
    t.integer  "bid_id"
    t.integer  "user_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wallet_id"
    t.integer  "past_amount", default: 0
  end

  add_index "investments", ["bid_id"], name: "index_investments_on_bid_id", using: :btree
  add_index "investments", ["user_id", "created_at"], name: "index_investments_on_user_id_and_created_at", using: :btree
  add_index "investments", ["wallet_id"], name: "index_investments_on_wallet_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.integer  "initial_cash",    default: 0
    t.integer  "actual_cash",     default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "wallets", force: true do |t|
    t.integer  "actual_cash",  default: 0
    t.integer  "initial_cash", default: 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallets", ["user_id"], name: "index_wallets_on_user_id", using: :btree

end

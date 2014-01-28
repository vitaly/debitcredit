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

ActiveRecord::Schema.define(version: 20140128131859) do

  create_table "debitcredit_accounts", force: true do |t|
    t.string   "name",           limit: 16,                                        null: false
    t.string   "type",           limit: 32,                                        null: false
    t.integer  "reference_id"
    t.string   "reference_type", limit: 32
    t.decimal  "balance",                   precision: 20, scale: 2, default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debitcredit_accounts", ["name", "reference_id", "reference_type"], name: "uindex", unique: true

  create_table "debitcredit_items", force: true do |t|
    t.integer  "transaction_id",                                        null: false
    t.integer  "account_id",                                            null: false
    t.boolean  "debit",                                                 null: false
    t.string   "comment"
    t.decimal  "amount",         precision: 20, scale: 2, default: 0.0, null: false
    t.decimal  "balance",        precision: 20, scale: 2, default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debitcredit_items", ["account_id"], name: "index_debitcredit_items_on_account_id"
  add_index "debitcredit_items", ["transaction_id"], name: "index_debitcredit_items_on_transaction_id"

  create_table "debitcredit_transactions", force: true do |t|
    t.integer  "reference_id"
    t.string   "reference_type",        limit: 32
    t.string   "kind"
    t.string   "description",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_transaction_id"
  end

  add_index "debitcredit_transactions", ["parent_transaction_id"], name: "index_debitcredit_transactions_on_parent_transaction_id"
  add_index "debitcredit_transactions", ["reference_id", "reference_type", "id"], name: "rindex"

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

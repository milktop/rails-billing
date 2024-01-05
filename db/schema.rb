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

ActiveRecord::Schema[7.0].define(version: 2024_01_04_154806) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acts", force: :cascade do |t|
    t.string "name", null: false
    t.integer "unit_price_cents", null: false
    t.integer "tax_rate", default: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_credits", force: :cascade do |t|
    t.date "date", null: false
    t.date "expiry_date"
    t.bigint "client_id", null: false
    t.bigint "credit_note_id"
    t.integer "amount_cents", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_credits_on_client_id"
    t.index ["credit_note_id"], name: "index_client_credits_on_credit_note_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clinics", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "consultations", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "clinic_id", null: false
    t.bigint "client_id", null: false
    t.text "motive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_consultations_on_client_id"
    t.index ["clinic_id"], name: "index_consultations_on_clinic_id"
  end

  create_table "credit_notes", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "clinic_id", null: false
    t.bigint "client_id", null: false
    t.bigint "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "redeemable", default: true
    t.index ["client_id"], name: "index_credit_notes_on_client_id"
    t.index ["clinic_id"], name: "index_credit_notes_on_clinic_id"
    t.index ["invoice_id"], name: "index_credit_notes_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.date "date", null: false
    t.date "due_date"
    t.bigint "client_id", null: false
    t.bigint "clinic_id", null: false
    t.integer "net_price_cents", null: false
    t.integer "gross_price_cents", null: false
    t.integer "tax_amount_cents", null: false
    t.integer "discount_amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["clinic_id"], name: "index_invoices_on_clinic_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "unit_price_cents", default: 0, null: false
    t.integer "tax_rate", default: 20, null: false
    t.integer "discount_rate", default: 0, null: false
    t.bigint "invoice_id"
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.bigint "client_id", null: false
    t.bigint "clinic_id", null: false
    t.integer "quantity", default: 1, null: false
    t.string "name", null: false
    t.index ["client_id"], name: "index_line_items_on_client_id"
    t.index ["clinic_id"], name: "index_line_items_on_clinic_id"
    t.index ["invoice_id"], name: "index_line_items_on_invoice_id"
    t.index ["resource_type", "resource_id"], name: "index_line_items_on_resource"
  end

  create_table "payment_allocations", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "payment_id", null: false
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_payment_allocations_on_invoice_id"
    t.index ["payment_id"], name: "index_payment_allocations_on_payment_id"
  end

  create_table "payments", force: :cascade do |t|
    t.date "date", null: false
    t.integer "payment_method", default: 0, null: false
    t.bigint "client_id", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_credit_id"
    t.index ["client_credit_id"], name: "index_payments_on_client_credit_id"
    t.index ["client_id"], name: "index_payments_on_client_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.integer "unit_price_cents", null: false
    t.integer "tax_rate", default: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "clinic_id", null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_sales_on_client_id"
    t.index ["clinic_id"], name: "index_sales_on_clinic_id"
  end

  add_foreign_key "client_credits", "clients"
  add_foreign_key "client_credits", "credit_notes"
  add_foreign_key "consultations", "clients"
  add_foreign_key "consultations", "clinics"
  add_foreign_key "credit_notes", "clients"
  add_foreign_key "credit_notes", "clinics"
  add_foreign_key "credit_notes", "invoices"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "clinics"
  add_foreign_key "line_items", "clients"
  add_foreign_key "line_items", "clinics"
  add_foreign_key "line_items", "invoices"
  add_foreign_key "payment_allocations", "invoices"
  add_foreign_key "payment_allocations", "payments"
  add_foreign_key "payments", "client_credits"
  add_foreign_key "payments", "clients"
  add_foreign_key "sales", "clients"
  add_foreign_key "sales", "clinics"
end

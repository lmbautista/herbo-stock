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

ActiveRecord::Schema[7.0].define(version: 2022_06_24_110733) do
  create_table "audits", force: :cascade do |t|
    t.string "operation_id", null: false
    t.text "raw_params", null: false
    t.string "status", null: false
    t.datetime "started_at"
    t.datetime "succeeded_at"
    t.datetime "failed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "message"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_scopes"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "v1_products", force: :cascade do |t|
    t.string "sku", null: false
    t.string "definicion", null: false
    t.text "ampliacion", null: false
    t.integer "disponible", null: false
    t.float "iva", null: false
    t.float "req_eq", null: false
    t.float "pvd", null: false
    t.float "pvd_iva", null: false
    t.float "pvd_iva_rec", null: false
    t.float "pvp", null: false
    t.float "peso", null: false
    t.string "ean", null: false
    t.boolean "hay_foto", null: false
    t.string "imagen", null: false
    t.datetime "fecha_imagen", null: false
    t.string "cat", null: false
    t.string "marca", null: false
    t.boolean "frio", null: false
    t.boolean "congelado", null: false
    t.boolean "bio", null: false
    t.boolean "apto_diabetico", null: false
    t.boolean "gluten", null: false
    t.boolean "huevo", null: false
    t.boolean "lactosa", null: false
    t.boolean "apto_vegano", null: false
    t.string "unidad_medida", null: false
    t.float "cantidad_medida", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "external_id"
    t.integer "shop_id", null: false
    t.index ["shop_id"], name: "index_v1_products_on_shop_id"
  end

  add_foreign_key "v1_products", "shops"
end

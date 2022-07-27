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

ActiveRecord::Schema[7.0].define(version: 2022_07_27_062203) do
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
    t.string "shop_domain", null: false
    t.index ["shop_domain"], name: "index_audits_on_shop_domain"
  end

  create_table "catalog_loader_schedulers", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.string "time_unit", null: false
    t.integer "time_amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "next_scheduled_at"
    t.index ["shop_id"], name: "index_catalog_loader_schedulers_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_scopes"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "v1_product_external_resources", force: :cascade do |t|
    t.integer "v1_product_id", null: false
    t.integer "external_id"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_v1_product_external_resources_on_external_id"
    t.index ["v1_product_id"], name: "index_v1_product_external_resources_on_v1_product_id"
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
    t.string "ean"
    t.boolean "hay_foto", null: false
    t.string "imagen", null: false
    t.datetime "fecha_imagen", null: false
    t.string "cat", null: false
    t.string "marca"
    t.boolean "frio", null: false
    t.boolean "congelado", null: false
    t.boolean "bio", null: false
    t.boolean "apto_diabetico", null: false
    t.boolean "gluten", null: false
    t.boolean "huevo", null: false
    t.boolean "lactosa", null: false
    t.boolean "apto_vegano", null: false
    t.string "unidad_medida"
    t.float "cantidad_medida", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shop_id", null: false
    t.index ["shop_id"], name: "index_v1_products_on_shop_id"
  end

  create_table "v1_webhooks", force: :cascade do |t|
    t.string "topic", null: false
    t.json "body", null: false
    t.string "status", null: false
    t.string "message"
    t.integer "retries", default: 0, null: false
    t.datetime "succeeded_at"
    t.datetime "failed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shop_domain", null: false
    t.index ["shop_domain"], name: "index_v1_webhooks_on_shop_domain"
  end

  add_foreign_key "catalog_loader_schedulers", "shops"
  add_foreign_key "v1_product_external_resources", "v1_products"
  add_foreign_key "v1_products", "shops"
end

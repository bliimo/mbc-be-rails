# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_26_081308) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "country"
    t.string "province"
    t.string "city"
    t.string "barangay"
    t.string "address_information"
    t.string "postal_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "billing_addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "buyer_id", null: false
    t.string "contact_name"
    t.string "contact_number"
    t.string "label"
    t.bigint "address_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_billing_addresses_on_address_id"
    t.index ["buyer_id"], name: "index_billing_addresses_on_buyer_id"
  end

  create_table "buyers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_buyers_on_user_id"
  end

  create_table "carts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "buyer_id", null: false
    t.bigint "product_id", null: false
    t.integer "variation_id"
    t.integer "quantity"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyer_id"], name: "index_carts_on_buyer_id"
    t.index ["product_id"], name: "index_carts_on_product_id"
  end

  create_table "carts_option_items", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "cart_id"
    t.bigint "option_item_id"
    t.index ["cart_id"], name: "index_carts_option_items_on_cart_id"
    t.index ["option_item_id"], name: "index_carts_option_items_on_option_item_id"
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "conversation_member_id", null: false
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["conversation_member_id"], name: "index_chats_on_conversation_member_id"
  end

  create_table "conversation_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "conversation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["conversation_id"], name: "index_conversation_members_on_conversation_id"
    t.index ["user_id"], name: "index_conversation_members_on_user_id"
  end

  create_table "conversations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exclusive_contents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "playmate_id", null: false
    t.text "description"
    t.integer "price"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["playmate_id"], name: "index_exclusive_contents_on_playmate_id"
  end

  create_table "exclusive_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "exclusive_content_id", null: false
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exclusive_content_id"], name: "index_exclusive_items_on_exclusive_content_id"
  end

  create_table "gifted_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "gift_id", null: false
    t.bigint "streaming_room_id", null: false
    t.bigint "user_id", null: false
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gift_id"], name: "index_gifted_items_on_gift_id"
    t.index ["streaming_room_id"], name: "index_gifted_items_on_streaming_room_id"
    t.index ["user_id"], name: "index_gifted_items_on_user_id"
  end

  create_table "gifts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "in_app_currency_transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "transaction_number"
    t.bigint "user_id", null: false
    t.integer "amount"
    t.decimal "price", precision: 10
    t.integer "transaction_method"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "in_app_store_id"
    t.integer "gifted_item_id"
    t.integer "streaming_room_id"
    t.integer "exclusive_content_id"
    t.index ["user_id"], name: "index_in_app_currency_transactions_on_user_id"
  end

  create_table "in_app_stores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "amount"
    t.decimal "price", precision: 10
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "merchants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "address_id", null: false
    t.string "shop_name"
    t.text "shop_description"
    t.integer "account_type"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "approval_status"
    t.index ["address_id"], name: "index_merchants_on_address_id"
    t.index ["user_id"], name: "index_merchants_on_user_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "streaming_room_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "message_type"
    t.integer "gifted_item_id"
    t.index ["streaming_room_id"], name: "index_messages_on_streaming_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "option_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "name"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_option_groups_on_product_id"
  end

  create_table "option_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "option_group_id", null: false
    t.string "name"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["option_group_id"], name: "index_option_items_on_option_group_id"
  end

  create_table "option_items_order_items", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_item_id"
    t.bigint "option_item_id"
    t.index ["option_item_id"], name: "index_option_items_order_items_on_option_item_id"
    t.index ["order_item_id"], name: "index_option_items_order_items_on_order_item_id"
  end

  create_table "order_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "variation_id"
    t.integer "quantity"
    t.decimal "order_discount", precision: 10, scale: 2
    t.decimal "order_price", precision: 10, scale: 2
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "buyer_id", null: false
    t.bigint "merchant_id", null: false
    t.string "delivery_address"
    t.string "contact_information"
    t.string "contact_person"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyer_id"], name: "index_orders_on_buyer_id"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  create_table "playmates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_playmates_on_user_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "name"
    t.string "brand"
    t.text "details"
    t.text "specification"
    t.decimal "discount", precision: 10
    t.decimal "price", precision: 10, scale: 2
    t.integer "stock"
    t.integer "status"
    t.integer "approval_status"
    t.integer "visibility"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "variation_title"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "products_tags", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "product_id"
    t.index ["product_id"], name: "index_products_tags_on_product_id"
    t.index ["tag_id"], name: "index_products_tags_on_tag_id"
  end

  create_table "streaming_rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "playmate_id", null: false
    t.string "stream_id"
    t.string "stream_data"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price"
    t.datetime "schedule"
    t.index ["playmate_id"], name: "index_streaming_rooms_on_playmate_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "contact_number"
    t.string "name"
    t.integer "gender"
    t.date "birthday"
    t.integer "role"
    t.integer "status"
    t.string "confirmation_token"
    t.datetime "verified_at"
    t.string "verification_code"
    t.datetime "verification_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_variations_on_product_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "billing_addresses", "addresses"
  add_foreign_key "billing_addresses", "buyers"
  add_foreign_key "buyers", "users"
  add_foreign_key "carts", "buyers"
  add_foreign_key "carts", "products"
  add_foreign_key "chats", "conversation_members"
  add_foreign_key "conversation_members", "conversations"
  add_foreign_key "conversation_members", "users"
  add_foreign_key "exclusive_contents", "playmates"
  add_foreign_key "exclusive_items", "exclusive_contents"
  add_foreign_key "gifted_items", "gifts"
  add_foreign_key "gifted_items", "streaming_rooms"
  add_foreign_key "gifted_items", "users"
  add_foreign_key "in_app_currency_transactions", "users"
  add_foreign_key "merchants", "addresses"
  add_foreign_key "merchants", "users"
  add_foreign_key "messages", "streaming_rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "option_groups", "products"
  add_foreign_key "option_items", "option_groups"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "buyers"
  add_foreign_key "orders", "merchants"
  add_foreign_key "playmates", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "streaming_rooms", "playmates"
  add_foreign_key "variations", "products"
end

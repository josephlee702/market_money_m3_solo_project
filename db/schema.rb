ActiveRecord::Schema[7.1].define(version: 2023_12_05_035728) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "market_vendors", force: :cascade do |t|
    t.bigint "market_id"
    t.bigint "vendor_id"
    t.index ["market_id"], name: "index_market_vendors_on_market_id"
    t.index ["vendor_id"], name: "index_market_vendors_on_vendor_id"
  end

  create_table "markets", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "city"
    t.string "county"
    t.string "state"
    t.string "zip"
    t.string "lat"
    t.string "lon"
    t.integer "vendor_count"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "contact_name"
    t.string "contact_phone"
    t.boolean "credit_accepted"
  end

  add_foreign_key "market_vendors", "markets"
  add_foreign_key "market_vendors", "vendors"
end

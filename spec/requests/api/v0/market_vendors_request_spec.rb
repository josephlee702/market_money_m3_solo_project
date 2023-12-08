require 'rails_helper'

describe "Market Vendors API" do
  it "creates a MarketVendor" do
    market = create(:market)
    vendor = create(:vendor)
    market_vendor_params = { market_id: market.id, vendor_id: vendor.id}

    post "/api/v0/markets_vendors", params: { market_vendor: market_vendor_params }

    expect(response.status).to eq(201)
    expect(response).to be_successful
    
    market_vendor_data = JSON.parse(response.body, symbolize_names: true)
    market_vendors = market_vendor_data[:data]
  end

  #marketvendor create sad path #1
  it "market has invalid id" do
    vendor = create(:vendor)
    market_vendor_params = { market_id: 5555, vendor_id: vendor.id}
  
    post "/api/v0/markets_vendors", params: { market_vendor: market_vendor_params }

    expect(response.status).to eq(404)
    expect(response).to_not be_successful
  
    market_data = JSON.parse(response.body, symbolize_names: true)
    market = market_data[:data]
  end

  #marketvendor create sad path #2
  it "returns error when marketvendor already exists" do
    market = create(:market)
    vendor = create(:vendor)
    market_vendor_params = { market_id: market.id, vendor_id: vendor.id}
    MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
  
    post "/api/v0/markets_vendors", params: { market_vendor: market_vendor_params }

    expect(response.status).to eq(404)
    expect(response).to_not be_successful
  
    market_data = JSON.parse(response.body, symbolize_names: true)
    market = market_data[:data]
  end


end
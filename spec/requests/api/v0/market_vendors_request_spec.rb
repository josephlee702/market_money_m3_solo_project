require 'rails_helper'

describe "Market Vendors API" do
  it "creates a MarketVendor" do
    market = create(:market)
    vendor = create(:vendor)
    expect(MarketVendor.count).to eq(0)

    post "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor.id }

    expect(response.status).to eq(201)
    expect(response).to be_successful 
    
    market_vendor_data = JSON.parse(response.body, symbolize_names: true)
    expect(market_vendor_data[:message]).to eq("Successfully added vendor to market")
    expect(MarketVendor.count).to eq(1)
  end

  it "market has invalid id" do
    vendor = create(:vendor)
    expect(MarketVendor.count).to eq(0)
  
    post "/api/v0/market_vendors", params: { market_id: 555555555, vendor_id: vendor.id }

    expect(response.status).to eq(404)
    expect(response).to_not be_successful
  
    market_data = JSON.parse(response.body, symbolize_names: true)
    expect(market_data[:errors].first[:detail]).to eq("Validation failed: Market must exist")
    expect(MarketVendor.count).to eq(0)
  end

  it "vendor has invalid id" do
    market = create(:market)
    expect(MarketVendor.count).to eq(0)
  
    post "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: 2223423 }

    expect(response.status).to eq(404)
    expect(response).to_not be_successful
  
    market_data = JSON.parse(response.body, symbolize_names: true)
    expect(market_data[:errors].first[:detail]).to eq("Validation failed: Vendor must exist")
    expect(MarketVendor.count).to eq(0)
  end

  it "market has blank id" do
    vendor = create(:vendor)
    expect(MarketVendor.count).to eq(0)
  
    post "/api/v0/market_vendors", params: { market_id: "", vendor_id: vendor.id }

    expect(response.status).to eq(400)
    expect(response).to_not be_successful
  
    market_data = JSON.parse(response.body, symbolize_names: true)
    expect(market_data[:errors].first[:detail]).to eq("Market ID or Vendor ID cannot be blank")
    expect(MarketVendor.count).to eq(0)
  end

  it "returns error when marketvendor already exists" do
    market = create(:market)
    vendor = create(:vendor)
    MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
  
    post "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor.id }

    expect(response.status).to eq(422)
    expect(response).to_not be_successful
  
    market_data = JSON.parse(response.body, symbolize_names: true)
    expect(market_data[:errors].first[:detail]).to eq("Validation failed: Market vendor association between market with #{market.id} and #{vendor.id} already exists")
    expect(MarketVendor.count).to eq(1)
  end

  it "deletes a marketvendor" do
    market = create(:market)
    vendor = create(:vendor)
    MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
    expect(MarketVendor.count).to eq(1)

    delete "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor.id }

    expect(response.status).to eq(204)
    expect(response).to be_successful

    expect(MarketVendor.count).to eq(0)
  end
#delete market_vendor sad path
  it "does not delete a market with an invalid market_id and/or vendor_id" do
    market = create(:market)
    vendor = create(:vendor)
    MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
    expect(MarketVendor.count).to eq(1)

    delete "/api/v0/market_vendors", params: { market_id: 5551232, vendor_id: 123123221 }

    expect(response.status).to eq(204)
    expect(response).to be_successful
    
    expect(response.body).to eq("")
    expect(MarketVendor.count).to eq(1)
  end
end
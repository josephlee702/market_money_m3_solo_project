require 'rails_helper'

describe "Markets API" do
  it "sends a list of markets" do
    create_list(:market, 3)

    get '/api/v0/markets'

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets.count).to eq(3)

    markets.each do |market|
      expect(market).to have_key(:name)
      expect(market[:name]).to be_an(String)

      expect(market).to have_key(:street)
      expect(market[:street]).to be_a(String)

      expect(market).to have_key(:city)
      expect(market[:city]).to be_a(String)

      expect(market).to have_key(:county)
      expect(market[:county]).to be_a(String)

      expect(market).to have_key(:state)
      expect(market[:state]).to be_a(String)

      expect(market).to have_key(:zip)
      expect(market[:zip]).to be_an(String)

      expect(market).to have_key(:lat)
      expect(market[:lat]).to be_an(String)

      expect(market).to have_key(:lon)
      expect(market[:lon]).to be_an(String)

      expect(market).to have_key(:vendor_count)
      expect(market[:vendor_count]).to be_an(Integer)
    end
  end

  it "can get one market by its id" do
    id = create(:market).id
  
    get "/api/v0/markets/#{id}"
  
    market = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to be_successful
  
    expect(market).to have_key(:name)
    expect(market[:name]).to be_an(String)

    expect(market).to have_key(:street)
    expect(market[:street]).to be_a(String)

    expect(market).to have_key(:city)
    expect(market[:city]).to be_a(String)

    expect(market).to have_key(:county)
    expect(market[:county]).to be_a(String)

    expect(market).to have_key(:state)
    expect(market[:state]).to be_a(String)

    expect(market).to have_key(:zip)
    expect(market[:zip]).to be_an(String)

    expect(market).to have_key(:lat)
    expect(market[:lat]).to be_an(String)

    expect(market).to have_key(:lon)
    expect(market[:lon]).to be_an(String)

    expect(market).to have_key(:vendor_count)
    expect(market[:vendor_count]).to be_an(Integer)
  end

  it "can get all vendors for a market" do
    new_market = create(:market)
    id = new_market.id
    vendor = create(:vendor)
    new_market.vendors << vendor

    get "/api/v0/markets/#{id}/vendors"

    market = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
  
    expect(market).to have_key(:name)
    expect(market[:name]).to be_an(String)
  end
end
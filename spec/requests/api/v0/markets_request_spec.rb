require 'rails_helper'

describe "Markets API" do
  it "sends a list of markets" do
    create_list(:market, 3)

    get '/api/v0/markets'

    expect(response).to be_successful

    markets_data = JSON.parse(response.body, symbolize_names: true)
    markets = markets_data[:data]

    expect(markets.count).to eq(3)

    markets.each do |market|
      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_an(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_an(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_an(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_an(String)

      expect(market[:attributes]).to have_key(:vendor_count)
      expect(market[:attributes][:vendor_count]).to be_an(Integer)
    end
  end

  #market show happy path
  it "can get one market by its id" do
    id = create(:market).id
  
    get "/api/v0/markets/#{id}"
  
    market_data = JSON.parse(response.body, symbolize_names: true)
    market = market_data[:data]
  
    expect(response).to be_successful

    expect(market[:attributes]).to have_key(:name)
    expect(market[:attributes][:name]).to be_an(String)

    expect(market[:attributes]).to have_key(:street)
    expect(market[:attributes][:street]).to be_a(String)

    expect(market[:attributes]).to have_key(:city)
    expect(market[:attributes][:city]).to be_a(String)

    expect(market[:attributes]).to have_key(:county)
    expect(market[:attributes][:county]).to be_a(String)

    expect(market[:attributes]).to have_key(:state)
    expect(market[:attributes][:state]).to be_a(String)

    expect(market[:attributes]).to have_key(:zip)
    expect(market[:attributes][:zip]).to be_an(String)

    expect(market[:attributes]).to have_key(:lat)
    expect(market[:attributes][:lat]).to be_an(String)

    expect(market[:attributes]).to have_key(:lon)
    expect(market[:attributes][:lon]).to be_an(String)

    expect(market[:attributes]).to have_key(:vendor_count)
    expect(market[:attributes][:vendor_count]).to be_an(Integer)
  end

  #market show sad path
  it "will gracefully handle if a market id doesn't exist" do
    get "/api/v0/markets/123222132"
 
    expect(response).to have_http_status(404)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:message]).to eq("Couldn't find Market with 'id'=123222132")

    expect(data).to have_key(:errors)
    expect(data[:errors].first).to have_key(:status)
    expect(data[:errors].first).to have_key(:message)
  end

  it "can get all vendors for a market" do
    new_market = create(:market)
    id = new_market.id
    vendor_1 = create(:vendor)
    new_market.vendors << vendor_1

    get "/api/v0/markets/#{id}/vendors"

    market = JSON.parse(response.body, symbolize_names: true)
    market_attributes = market[:data].first[:attributes]
    expect(response).to be_successful

    expect(new_market.vendors.count).to be(1)
    
    expect(market_attributes[:name]).to be_an(String)
    expect(market_attributes[:description]).to be_an(String)
    expect(market_attributes[:contact_name]).to be_an(String)
    expect(market_attributes[:contact_phone]).to be_an(String)
    expect(market_attributes[:credit_accepted]).to be_in([true,false])
  end
end
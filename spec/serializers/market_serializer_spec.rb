require "rails_helper"

RSpec.describe MarketSerializer, type: :request do

  describe 'Serializing' do
    it "can serialize" do
      create_list(:market, 5)
      market_serializer = MarketSerializer.new(Market.all)

      get "/api/v0/markets"

      expect(response).to be_successful
      data = JSON.parse(response.body)

      market = data["data"][0]

      expect(market).to have_key("id")
      expect(market["id"]).to be_a String

      expect(market).to have_key("type")
      expect(market["type"]).to eq("market")

      expect(market["attributes"]).to have_key("name")
      expect(market["attributes"]["name"]).to be_a String

      expect(market["attributes"]).to have_key("city")
      expect(market["attributes"]["city"]).to be_a String

      expect(market["attributes"]).to have_key("county")
      expect(market["attributes"]["county"]).to be_a String

      expect(market["attributes"]).to have_key("state")
      expect(market["attributes"]["state"]).to be_a String

      expect(market["attributes"]).to have_key("zip")
      expect(market["attributes"]["zip"]).to be_a String

      expect(market["attributes"]).to have_key("lat")
      expect(market["attributes"]["lat"]).to be_a String

      expect(market["attributes"]).to have_key("lon")
      expect(market["attributes"]["lon"]).to be_a String

      expect(market["attributes"]).to have_key("vendor_count")
      expect(market["attributes"]["vendor_count"]).to be_a Integer
    end
  end
end
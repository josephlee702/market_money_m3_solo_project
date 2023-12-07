require "rails_helper"

RSpec.describe VendorSerializer, type: :request do

  describe 'Serializing' do
    it "can serialize" do
      market = create(:market)
      vendor_serializer = VendorSerializer.new(Vendor.all)
      vendors = create_list(:vendor, 5)
      market.vendors << vendors
      expect(market.vendors.count).to eq(5)

      get "/api/v0/markets/#{market.id}/vendors"

      expect(response).to be_successful
      data = JSON.parse(response.body)

      vendor = data["data"][0]

      expect(vendor).to have_key("id")
      expect(vendor["id"]).to be_a String

      expect(vendor).to have_key("type")
      expect(vendor["type"]).to eq("vendor")

      expect(vendor["attributes"]).to have_key("name")
      expect(vendor["attributes"]["name"]).to be_a String

      expect(vendor["attributes"]).to have_key("description")
      expect(vendor["attributes"]["description"]).to be_a String

      expect(vendor["attributes"]).to have_key("contact_name")
      expect(vendor["attributes"]["contact_name"]).to be_a String

      expect(vendor["attributes"]).to have_key("contact_phone")
      expect(vendor["attributes"]["contact_phone"]).to be_a String

      expect(vendor["attributes"]).to have_key("credit_accepted")
      expect(vendor["attributes"]["credit_accepted"]).to be_in([true, false])
    end
  end
end
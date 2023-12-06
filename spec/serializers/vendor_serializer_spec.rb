require "rails_helper"

RSpec.describe VendorSerializer, type: :request do

  describe 'Serializing' do
    it "can serialize" do
      create_list(:vendor, 5)
      vendor_serializer = VendorSerializer.new(Vendor.all)

      get "/api/v0/vendors"

      expect(response).to be_successful
      data = JSON.parse(response.body)

      vendor = data["data"][0]

      expect(vendor).to have_key("id")
      expect(vendor["id"]).to be_a String

      expect(vendor).to have_key("type")
      expect(vendor["type"]).to eq("vendor")

      expect(vendor["attributes"]).to have_key("name")
      expect(vendor["attributes"]["name"]).to be_a String

      expect(vendor["attributes"]).to have_key("city")
      expect(vendor["attributes"]["city"]).to be_a String

      expect(vendor["attributes"]).to have_key("county")
      expect(vendor["attributes"]["county"]).to be_a String

      expect(vendor["attributes"]).to have_key("state")
      expect(vendor["attributes"]["state"]).to be_a String

      expect(vendor["attributes"]).to have_key("zip")
      expect(vendor["attributes"]["zip"]).to be_a String

      expect(vendor["attributes"]).to have_key("lat")
      expect(vendor["attributes"]["lat"]).to be_a String

      expect(vendor["attributes"]).to have_key("lon")
      expect(vendor["attributes"]["lon"]).to be_a String

      expect(vendor["attributes"]).to have_key("vendor_count")
      expect(vendor["attributes"]["vendor_count"]).to be_a Integer
    end
  end
end
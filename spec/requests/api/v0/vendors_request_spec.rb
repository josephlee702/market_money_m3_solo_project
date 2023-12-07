require 'rails_helper'

describe "Vendors API" do
  #happy path
  it "grabs one Vendor" do
    new_vendor = create(:vendor)
    id = new_vendor.id

    get "/api/v0/vendors/#{id}"

    expect(response).to be_successful

    vendor_data = JSON.parse(response.body, symbolize_names: true)
    vendor = vendor_data[:data]

    expect(vendor[:attributes]).to have_key(:name)
    expect(vendor[:attributes][:name]).to be_an(String)

    expect(vendor[:attributes]).to have_key(:description)
    expect(vendor[:attributes][:description]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:contact_name)
    expect(vendor[:attributes][:contact_name]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:contact_phone)
    expect(vendor[:attributes][:contact_phone]).to be_a(String)

    expect(vendor[:attributes]).to have_key(:credit_accepted)
    expect(vendor[:attributes][:credit_accepted]).to be_in([true,false])
  end

  #sad path
  it "will gracefully handle if a market id doesn't exist" do
    get "/api/v0/vendors/123222132"
 
    expect(response).to have_http_status(404)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:message]).to eq("Couldn't find Vendor with 'id'=123222132")

    expect(data).to have_key(:errors)
    expect(data[:errors].first).to have_key(:status)
    expect(data[:errors].first).to have_key(:message)
  end
end
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

  it "will create a vendor" do
    vendor_params = {name: "testing", description: "test", contact_name: "Joseph", contact_phone: "123-456-7890", credit_accepted: true}
  
    post "/api/v0/vendors", params: { vendor: vendor_params }
 
    expect(response).to be_successful
    expect(response.status).to eq(201)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).not_to have_key(:errors)

    expect(data[:data]).to have_key(:id)
    expect(data[:data][:id]).to be_a String
    
    expect(data[:data]).to have_key(:type)
    expect(data[:data][:type]).to be_a String
    expect(data[:data][:type]).to eq("vendor")

    expect(data[:data][:attributes][:name]).to be_a String
    expect(data[:data][:attributes][:description]).to be_a String
    expect(data[:data][:attributes][:contact_name]).to be_a String
    expect(data[:data][:attributes][:contact_phone]).to be_a String
    expect(data[:data][:attributes][:credit_accepted]).to be_in([true, false])
  end
end
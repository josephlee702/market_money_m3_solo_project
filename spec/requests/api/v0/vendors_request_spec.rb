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

  it "is the happy path for creating a vendor" do
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

  it "is the sad path for creating a vendor" do
    vendor_params = {name: "testing", description: "test", contact_name: "", contact_phone: "", credit_accepted: true}
  
    post "/api/v0/vendors", params: { vendor: vendor_params }
 
    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors].count).to eq(2)
    expect(data[:errors].first).to eq("Contact name can't be blank")
    expect(data[:errors].second).to eq("Contact phone can't be blank")
  end

  #happy path for update
  it "will update a vendor successfully" do
    vendor = create(:vendor)
    vendor_params = {name: "testing", description: "test", contact_name: "Joseph", contact_phone: "123-456-7890", credit_accepted: true}
  
    patch "/api/v0/vendors/#{vendor.id}", params: { vendor: vendor_params }
 
    expect(response).to be_successful
    expect(response.status).to eq(201)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).not_to have_key(:errors)

    expect(data[:data][:type]).to eq("vendor")
    expect(data[:data][:attributes][:name]).to eq("testing")
    expect(data[:data][:attributes][:description]).to eq("test")
    expect(data[:data][:attributes][:contact_name]).to eq("Joseph")
    expect(data[:data][:attributes][:contact_phone]).to eq("123-456-7890")
    expect(data[:data][:attributes][:credit_accepted]).to be(true)
  end

  it "will not update if Vendor id is not found" do
    vendor = create(:vendor)
    vendor_params = {name: "testing", description: "test", contact_name: "Joseph", contact_phone: "123-456-7890", credit_accepted: true}
  
    patch "/api/v0/vendors/123211", params: { vendor: vendor_params }
 
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors].count).to eq(1)
    expect(data[:errors].first[:message]).to eq("Couldn't find Vendor with 'id'=123211")
    expect(data[:errors].first[:status]).to eq("404")
  end

  it "will not update if contact name is blank" do
    vendor = create(:vendor)
    vendor_params = {name: "testing", description: "test", contact_name: "", contact_phone: "123-456-7890", credit_accepted: true}
  
    patch "/api/v0/vendors/#{vendor.id}", params: { vendor: vendor_params }
 
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors].count).to eq(1)
    expect(data[:errors]).to eq(["Contact name can't be blank"])
  end

  it "will delete a vendor" do
    vendor = create(:vendor)
    delete "/api/v0/vendors/#{vendor.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(response.body).to eq("")
    expect(Vendor.find_by(id: vendor.id)).to be_nil
  end

  it "will not delete if Vendor id is not found" do
    vendor = create(:vendor)
  
    delete "/api/v0/vendors/123211"
 
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors].count).to eq(1)
    expect(data[:errors].first[:message]).to eq("Couldn't find Vendor with 'id'=123211")
    expect(data[:errors].first[:status]).to eq("404")
  end
end
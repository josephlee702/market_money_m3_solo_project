FactoryBot.define do
  factory :market do
    name { Faker::Company.name }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { "#{Faker::Address.city} County" }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    vendor_count { Faker::Number.between(from: 1, to: 100) }
  end
end
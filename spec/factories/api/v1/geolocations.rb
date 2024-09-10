FactoryBot.define do
  factory :api_v1_geolocations, class: 'Api::V1::Geolocation' do
    city { Faker::Address.city }
    country { Faker::Address.country }
    country_code { Faker::Address.country_code }
    ip_address { Faker::Internet.ip_v4_address }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.postcode }
    province { Faker::Address.state }
    url { Faker::Internet.url }
    service_response { {a: :a, b: {b: :b}} }
  end
end

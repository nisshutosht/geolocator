require 'rails_helper'

RSpec.describe "/api/v1/geolocations", type: :request do
  describe "GET /show" do
    let!(:geolocation_record) { create :api_v1_geolocations }
    let(:record_hash) { geolocation_record.to_json }
    subject(:get_geolocation) { get api_v1_geolocation_path(request_params) }

    shared_context 'success response' do
      it 'should return the expected record' do
        subject
        expect(response.body).to eq(record_hash)
      end
    end

    context 'based on url' do
      let(:request_params) { {id: 'url', url: geolocation_record.url} }
      it_behaves_like 'success response'
    end

    context 'based on ip_address' do
      let(:request_params) { {id: 'ip_address', ip_address: geolocation_record.ip_address} }
      it_behaves_like 'success response'
    end

    context 'based on id' do
      let(:request_params) { {id: geolocation_record.id} }
      it_behaves_like 'success response'
    end
  end

  describe "POST /create" do
    subject(:create_geolocation) { post api_v1_geolocations_path, params: request_params }
    let(:client_service_response_hash) do
      {
        "ip"=>"2604:3d08:5e79:8e30:2df6:6a95:63bf:5f",
        "dma"=>nil,
        "msa"=>nil,
        "zip"=>"V5Y 0G6",
        "city"=>"West End",
        "type"=>"ipv6",
        "radius"=>nil,
        "latitude"=>49.27527618408203,
        "location"=>
        {"is_eu"=>false,
          "capital"=>"Ottawa",
          "languages"=>[{"code"=>"en", "name"=>"English", "native"=>"English"}, {"code"=>"fr", "name"=>"French", "native"=>"Français"}],
          "geoname_id"=>6178582,
          "calling_code"=>"1",
          "country_flag"=>"https://assets.ipstack.com/flags/ca.svg",
          "country_flag_emoji"=>"🇨🇦",
          "country_flag_emoji_unicode"=>"U+1F1E8 U+1F1E6"},
        "longitude"=>-123.13249969482422,
        "region_code"=>"BC",
        "region_name"=>"British Columbia",
        "country_code"=>"CA",
        "country_name"=>"Canada",
        "continent_code"=>"NA",
        "continent_name"=>"North America",
        "connection_type"=>nil,
        "ip_routing_type"=>nil
      }
    end

    shared_context 'creates new record' do
      it 'should create a new record' do
        expect { subject }.to change {Api::V1::Geolocation.count}.by(1)
      end
    end

    shared_context 'returns success' do
      it 'should return success' do
        subject
        expect(response.status).to eq(201)
      end
    end

    context 'based on url' do
      let(:url) { Faker::Internet.url }
      let(:request_params) { {url:} }
      let(:client_service_url) { "https://api.ipstack.com/#{URI.parse(url).hostname}?access_key=#{ENV['IPSTACK_API_KEY']}" }

      before do
        stub_request(
          :any, client_service_url
        ).to_return_json(
          body: client_service_response_hash
        )
      end

      it_behaves_like 'creates new record'
      it_behaves_like 'returns success'
    end

    context 'based on ip_address' do
      let(:ip_address) { Faker::Internet.ip_v4_address }
      let(:request_params) { {ip_address:} }
      let(:client_service_url) { "https://api.ipstack.com/#{ip_address}?access_key=#{ENV['IPSTACK_API_KEY']}" }

      before do
        stub_request(
          :any, client_service_url
        ).to_return_json(
          body: client_service_response_hash.merge('ip' => ip_address)
        )
      end

      it_behaves_like 'creates new record'
      it_behaves_like 'returns success'
    end
  end

  describe "DELETE /destroy" do
    let!(:geolocation_record) { create :api_v1_geolocations }
    subject(:delete_geolocation) { delete api_v1_geolocation_path(request_params) }

    shared_context 'should delete a record' do
      it 'should delete the requeted record' do
        subject
        expect(Api::V1::Geolocation.find_by(id: geolocation_record.id)).to be_nil
      end
    end
    shared_context 'should return expected response' do
      it 'should be a success' do
        subject
        expect(response.status).to eq(204)
      end
    end

    context 'based on ip_address' do
      let(:request_params) { { id: 'ip_address', ip_address: geolocation_record.ip_address } }
      it_behaves_like 'should delete a record'
      it_behaves_like 'should return expected response'
    end
    
    context 'based on url' do
      let(:request_params) { { id: 'url', url: geolocation_record.url } }
      it_behaves_like 'should delete a record'
      it_behaves_like 'should return expected response'
    end
    
    context 'based on id' do
      let(:request_params) { { id: geolocation_record.id } }
      it_behaves_like 'should delete a record'
      it_behaves_like 'should return expected response'
    end
  end
end

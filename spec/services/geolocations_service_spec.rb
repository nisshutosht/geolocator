require 'rails_helper'

RSpec.describe GeolocationService do
  let(:geolocation_service) { described_class.new user_input: Faker::Internet.ip_v4_address }

  describe '.initialize' do
    let(:subject) { described_class.new(**service_params) }

    shared_context 'raises InvalidInputType' do
      it 'should raise error' do
        expect {
          subject
        }.to raise_error(
          described_class::InvalidInputType, 'The input type needs to be IPv4 or IPv6 or a valid URL'
        )
      end
    end

    shared_context 'does not raise error' do
      it 'should not raise an error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'input_type url' do
      context 'when user_input is an invalid URL' do
        let(:service_params) { { user_input: 'invalid-ip-address' } }

        it_behaves_like 'raises InvalidInputType'
      end

      context 'when user_input is a valid URL' do
        let(:service_params) { { user_input: Faker::Internet.url } }

        it_behaves_like 'does not raise error'

        it 'should set input_type to url' do
          expect(subject.input_type).to eq(described_class::TYPE_URL)
        end
      end
    end

    context 'input_type ip_address' do
      context 'when user_input is an invalid ipv6' do
        let(:service_params) { { user_input: 'invalid-ip-address' } }
        it_behaves_like 'raises InvalidInputType'
      end

      context 'when user_input is a valid ipv6' do
        let(:service_params) { { user_input: Faker::Internet.ip_v6_address } }

        it_behaves_like 'does not raise error'

        it 'should set input_type to ipv6' do
          expect(subject.input_type).to eq(described_class::TYPE_IPV6)
        end
      end

      context 'when user_input is an invalid ipv4' do
        let(:service_params) { { user_input: 'invalid-ip-address' } }

        it_behaves_like 'raises InvalidInputType'
      end

      context 'when user_input is a valid ipv4' do
        let(:service_params) { { user_input: Faker::Internet.ip_v4_address } }

        it_behaves_like 'does not raise error'

        it 'should set input_type to ipv4' do
          expect(subject.input_type).to eq(described_class::TYPE_IPV4)
        end
      end
    end
  end

  describe '.save' do
    let(:geolocation_params) { attributes_for :api_v1_geolocations }
    let(:ip_address) { Faker::Internet.ip_v4_address }
    let(:subject) { described_class.new(user_input: ip_address).save }

    context 'when client response is success' do
      let(:client_service_response_hash) do
        {
          "ip"=>ip_address,
          "dma"=>nil,
          "msa"=>nil,
          "zip"=>"V5Y 0G6",
          "city"=>"West End",
          "type"=>"ipv6",
          "radius"=>nil,
          "latitude"=>49.27527618408203,
          "location"=>
          { "is_eu"=>false,
            "capital"=>"Ottawa",
            "languages"=>[ { "code"=>"en", "name"=>"English", "native"=>"English" }, { "code"=>"fr", "name"=>"French", "native"=>"Français" } ],
            "geoname_id"=>6178582,
            "calling_code"=>"1",
            "country_flag"=>"https://assets.ipstack.com/flags/ca.svg",
            "country_flag_emoji"=>"🇨🇦",
            "country_flag_emoji_unicode"=>"U+1F1E8 U+1F1E6" },
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
      let(:client_service_url) { "https://api.ipstack.com/#{ip_address}?access_key=#{ENV['IPSTACK_API_KEY']}" }
  
      before do
        stub_request(
          :any, client_service_url
        ).to_return_json(
          body: client_service_response_hash
        )
      end

      it 'should save geolocation record' do
        expect { subject }.to change { Api::V1::Geolocation.count }.by(1)
      end
    end

    context 'when client response is not success' do
      before do
        allow_any_instance_of(Ipstack::Client).to receive(:get_json_response).and_return(nil)
        allow_any_instance_of(
          Ipstack::Client
        ).to receive(
          :get_service_error_message
        ).and_return(
          'Any error message'
        )
      end

      it 'should not incease geolocation record count' do
        expect { subject }.not_to change(Api::V1::Geolocation, :count)
      end
    end
  end
end

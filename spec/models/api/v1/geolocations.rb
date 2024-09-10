require 'rails_helper'

RSpec.describe Api::V1::Geolocation, type: :model do
  let(:geolocation_attributes) { attributes_for :api_v1_geolocations }
  
  context 'when ipv4' do
    let(:subject) { described_class.new(geolocation_attributes) }

    context 'when ip_address is invalid' do
      let(:geolocation_attributes) { attributes_for(:api_v1_geolocations).merge(ip_address: 'invalid-ip-address') }

      it 'should return an error' do
        subject.valid?
        expect(subject.errors.messages[:ip_address].first).to eq('Should be valid')
      end
    end

    context 'when ip_address is valid' do
      it 'should return true' do
        expect(subject.valid?).to be_truthy
      end
    end
  end

  context 'when ipv6' do
    let(:subject) { described_class.new(geolocation_attributes) }

    context 'when ip_address is invalid' do
      let(:geolocation_attributes) { attributes_for(:api_v1_geolocations).merge(ip_address: 'invalid-ip-address') }

      it 'should return an error' do
        subject.valid?
        expect(subject.errors.messages[:ip_address].first).to eq('Should be valid')
      end
    end

    context 'when ip_address is valid' do
      let(:geolocation_attributes) { attributes_for :api_v1_geolocations, ip_address: Faker::Internet.ip_v6_address }

      it 'should return true' do
        expect(subject.valid?).to be_truthy
      end
    end
  end

  context 'when url is present' do
    let(:subject) { described_class.new(geolocation_attributes) }

    context 'when url is invalid' do
      let(:geolocation_attributes) { attributes_for(:api_v1_geolocations).merge(url: 'invalid-url') }

      it 'should return an error' do
        subject.valid?
        expect(subject.errors.messages[:url].first).to eq('Should be valid')
      end
    end

    context 'when url is valid' do
      let(:geolocation_attributes) { attributes_for :api_v1_geolocations }

      it 'should return true' do
        expect(subject.valid?).to be_truthy
      end
    end
  end
end

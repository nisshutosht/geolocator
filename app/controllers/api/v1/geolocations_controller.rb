class Api::V1::GeolocationsController < ApplicationController
  before_action :set_api_v1_geolocation, only: %i[ show destroy ]

  # GET /api/v1/geolocations/1
  def show
    render json: @geolocation
  end

  # POST /api/v1/geolocations
  def create
    geolocation_service = GeolocationService.new(
      # Send sanitized input without whitespaces around the input
      user_input: geolocation_params[:ip_address]&.strip || geolocation_params[:url]&.strip
    )
    geolocation_record = geolocation_service.save

    if geolocation_record.persisted?
      render json: geolocation_record, status: :created, location: geolocation_record
    else
      render json: geolocation_record.errors, status: :unprocessable_entity
    end
  rescue GeolocationService::InvalidInputType => e
    render json: { error_message: e.message }, status: :unprocessable_entity
  end

  # DELETE /api/v1/geolocations/1
  def destroy
    @geolocation.destroy!
  end

  private

  def set_api_v1_geolocation
    @geolocation = case
    when geolocation_params[:ip_address].present?
      Api::V1::Geolocation.find_by!(ip_address: geolocation_params[:ip_address])
    when geolocation_params[:url].present?
      Api::V1::Geolocation.find_by!(url: geolocation_params[:url])
    else
      Api::V1::Geolocation.find(params[:id])
    end
  end

  def geolocation_params
    params.permit(:ip_address, :url)
  end
end

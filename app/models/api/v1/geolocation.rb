class Api::V1::Geolocation < ApplicationRecord
  include InputVerifierMethods

  validates :ip_address,
            :latitude,
            :longitude,
            :city,
            :country_code,
            :country,
            :province,
            :service_response,
            presence: true

  validate :is_valid_url_when_present?, :is_valid_ip_address?

  private

  def is_valid_url_when_present?
    # Empty URL is ok
    return unless url.present?
    
    # If url is present, it should be valid
    return if url.present? && url?(url)
    
    # TODO: Should come via Internationalization/I18n
    errors.add :url, 'Should be valid'
  end

  def is_valid_ip_address?
    return if ipv4?(ip_address) || ipv6?(ip_address)

    # TODO: Should come via Internationalization/I18n
    errors.add :ip_address, 'Should be valid'
  end
end

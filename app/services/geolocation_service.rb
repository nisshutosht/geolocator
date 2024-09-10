class GeolocationService
  include InputVerifierMethods

  class InvalidInputType < StandardError; end

  GEOLOCATION_CLIENTS = [
    CLIENT_IPSTACK = Ipstack::Client
  ]

  DEFAULT_CLIENT = CLIENT_IPSTACK

  USER_INPUT_TYPES = [
    TYPE_IPV6 = :ipv6,
    TYPE_IPV4 = :ipv4,
    TYPE_URL = :url
  ]

  attr_reader :user_input, :input_type, :geolocation_record

  def initialize(user_input:, preferred_client: nil)
    @user_input = user_input
    @input_type = get_input_type
    @client = preferred_client || DEFAULT_CLIENT
  end

  def save
    @geolocation_record = set_geolocation_record

    if get_json_response.present?
      @geolocation_record.assign_attributes(get_json_response)
      @geolocation_record.service_response = client_object.service_response
      @geolocation_record.save
    else
      @geolocation_record.errors.add('Api Response', client_error_message)
    end

    @geolocation_record
  end

  protected

  def sanitized_search_input
    case
    when input_type == TYPE_URL
      URI.parse(user_input).hostname
    else
      user_input
    end
  end

  def get_json_response
    @get_json_response ||= client_object.get_json_response
  end

  def client_object
    @client_object ||= @client.new(search_input: sanitized_search_input)
  end

  def client_error_message
    client_object.get_service_error_message
  end

  def set_geolocation_record
    geolocation_record_params = {}
    geolocation_record_params[:url] = user_input if get_input_type == TYPE_URL
    geolocation_record_params[:ip_address] = user_input if [TYPE_IPV6, TYPE_IPV4].include?(user_input)

    Api::V1::Geolocation.new(geolocation_record_params)
  end

  def get_input_type
    return TYPE_IPV4 if ipv4?(user_input)
    return TYPE_IPV6 if ipv6?(user_input)
    return TYPE_URL if url?(user_input)

    # TODO: Should be via Internationalization/I18n
    raise InvalidInputType.new('The input type needs to be IPv4 or IPv6 or a valid URL')
  end
end

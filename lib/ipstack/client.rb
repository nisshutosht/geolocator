# This is a custom library created to consume Ipstack's REST API for fetching geolocation information for a URL or IP
#   For detailed information about the API service, please visit documentation: https://ipstack.com/documentation
#   This is based on documentation version available as on 8September 2024
module Ipstack
  class Client
    include HTTParty
    BASE_URI = 'https://api.ipstack.com'.freeze
    API_KEY = ENV.fetch('IPSTACK_API_KEY')

    attr_reader :search_input, :service_response

    def initialize(search_input:)
      @search_input = search_input
    end

    def get_json_response
      # success==false is only returned when an error message is being returned
      #   Not when it is a success response, there is no success==true
      return nil if service_response.parsed_response['success'] == false

      mapped_service_response
    end

    def mapped_service_response
      Ipstack::Attributes::ATTRIBUTES_MAP.map do |api_attribute, db_attribute|
        [db_attribute, service_response[api_attribute]]
      end.to_h
    end

    def service_response
      @service_response ||= HTTParty.get(
        "#{BASE_URI}/#{search_input}?access_key=#{API_KEY}",
        headers: json_headers
      )
    end

    def get_service_error_message
      log_ipstack_error_response

      # Most of these should be sanitized beforehand
      case service_response.parsed_response['error']['code']
      when 404 then 'The requested resource does not exist.' # 404_not_found
      when 101 then 'No API Key was specified.' # missing_access_key
      when 101 then 'No API Key was specified or an invalid API Key was specified.' # invalid_access_key
      when 102 then 'The current user account is not active. User will be prompted to get in touch with Customer Support.' # inactive_user
      when 103 then 'The requested API endpoint does not exist.' # invalid_api_function
      when 104 then 'The maximum allowed amount of monthly API requests has been reached.' # usage_limit_reached
      when 301 then 'One or more invalid fields were specified using the fields parameter.' # invalid_fields
      when 302 then 'Too many IPs have been specified for the Bulk Lookup Endpoint. (max. 50)' # too_many_ips
      else # This can be a 303, 5xx
        'Something went wrong'
      end
    end

    # Since using JSON data type by default for input and output, hence using JSON headers
    #   Although API also provides XML responses
    def json_headers
      {
        'accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
    end

    def log_ipstack_error_response
      Rails.logger.error("Ipstack Error: [#{service_response.parsed_response['error']['code']}] #{service_response} when input is=> #{search_input}")
    end
  end
end

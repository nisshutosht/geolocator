module Ipstack
  class Attributes
    ATTRIBUTES_MAP = {
      "ip" => "ip_address",
      "country_name" => "country",
      "country_code" => "country_code",
      "latitude" => "latitude",
      "longitude" => "longitude",
      "region_name" => "province",
      "city" => "city",
      "zip" => "postal_code"
    }.freeze
  end
end

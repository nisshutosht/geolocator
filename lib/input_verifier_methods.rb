require 'resolv'
require 'uri'

module InputVerifierMethods
  def ipv4?(input)
    input =~ Resolv::IPv4::Regex
  end
  
  def ipv6?(input)
    input =~ Resolv::IPv6::Regex
  end

  def url?(input)
    input =~ URI::regexp
  end
end
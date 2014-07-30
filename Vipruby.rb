require 'httparty'

class Vipruby
  include HTTParty
  
  def initialize(baseUri,auth_token,proxy_token)
    base_uri baseUri
    self.get_tenant
    @auth_token = auth_token
    @proxy_token = proxy_token
  end
  
  def get_tenant
    return get('/tenant', :header => {
      X-SDS-AUTH-TOKEN: @auth_token,
      X-SDS-AUTH-PROXY-TOKEN: @proxy_token
    })
  end
  
  attr_reader :tenant, :baseUri
  
  def self.getHosts(tenant)
    
  end
  
  def self.getHost(uid)
    
  end
end
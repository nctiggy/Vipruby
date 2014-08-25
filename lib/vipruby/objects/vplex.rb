require 'rest-client'
require 'json'

# ViPR configuration requirements for VPLEX storage systems
# ViPR supports VPLEX in a Local or Metro configuration. VPLEX Geo configurations are not supported. 
class Vplex

  def initialize (name, ip_address, port, user_name, password, use_ssl, api_url, verify_cert, auth_token)
    @name = name
    @ip_address = ip_address
    @port = port
    @user_name = user_name
    @password = password
    @use_ssl = use_ssl
    @api_url = api_url
    @verify_cert = verify_cert
    @auth_token = auth_token
  end
  
  def name
    @name
  end

  def ip_address
    @ip_address
  end
  
  def port
    @port
  end
  
  def user_name
    @user_name
  end

  def password
    @password
  end

  def use_ssl
  	@use_ssl
  end
  
  def api_url
    @api_url
  end

  def add
    payload = {
      name: @name,
      interface_type:  "vplex",
      ip_address: @ip_address,
      port_number: @port,
      user_name: @user_name,
      password: @password,
      use_ssl: @use_ssl
    }.to_json

    RestCall.rest_post(payload, @api_url, @verify_cert, @auth_token)
  end
end 

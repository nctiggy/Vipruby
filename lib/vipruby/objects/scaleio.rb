require 'rest-client'
require 'json'

  # Stand-alone ScaleIO support and preconfiguration requirements
  # Supported versions: ScaleIO 1.21.0.20 or later 
  # Preconfiguration requirements:
  # => Protection domains are defined.
  # => All storage pools are defined. 
class ScaleIO

  def initialize (name, ip_address, port, user_name, password, api_url, verify_cert, auth_token)
    @name = name
    @ip_address = ip_address
    @port = port
    @user_name = user_name
    @password = password
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
  
  def api_url
    @api_url
  end

  def add
    payload = {
      name: @name,
      interface_type: "scaleio"
      ip_address: @ip_address,
      port_number: @port,
      user_name: @user_name,
      password: @password
    }.to_json

    RestCall.rest_post(payload, @api_url, @verify_cert, @auth_token)
  end
end 

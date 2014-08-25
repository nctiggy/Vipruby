require 'rest-client'
require 'json'

  # Isilon Storage System Support
  # => Supported Protocol: NFS, CIFS (Snapshot restore is not supported for Isilon storage systems.)
  # Port (default is 8080) 
class Isilon

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
      system_type: "isilon"
      ip_address: @ip_address,
      port_number: @port,
      user_name: @user_name,
      password: @password
    }.to_json

    RestCall.rest_post(payload, @api_url, @verify_cert, @auth_token)
  end
end 

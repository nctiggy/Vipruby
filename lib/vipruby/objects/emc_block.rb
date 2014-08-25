require 'rest-client'
require 'json'

  # EMC VMAX and VNX for block storage system version support
  # => For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com)
  # The EMC SMI-S Provider (a component of EMC Solutions Enabler) is required to use VMAX storage or VNX block. 
  # The following information is required to verify & add the SMI-S provider storage systems to ViPR:
  # => SMI-S Provider host address
  # => SMI-S Provider credentials (default is admin/#1Password) 
  # => SMI-S Provider port (default is 5989)
class EMCblock

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
      interface_type:  "smis",
      ip_address: @ip_address,
      port_number: @port,
      user_name: @user_name,
      password: @password,
      use_ssl: @use_ssl
    }.to_json
    
    RestCall.rest_post(payload, @api_url, @verify_cert, @auth_token)
  end
end 

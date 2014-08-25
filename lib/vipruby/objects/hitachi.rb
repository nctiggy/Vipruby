require 'rest-client'
require 'json'

  # Hitachi Data Systems support
  # For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com).
  # Hitachi HiCommand Device Manager is required to use HDS storage with ViPR. 
  # You need to obtain the following information to configure and add the Hitachi HiCommand Device manager to ViPR:
  # => A host or virtual machine for HiCommand Device manager setup
  # => HiCommand Device Manager license, host address, credentials, and host port (default is 2001)  
class Hitachi

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
      interface_type:  "hicommand",
      ip_address: @ip_address,
      port_number: @port,
      user_name: @user_name,
      password: @password,
      use_ssl: @use_ssl
    }.to_json

    RestCall.rest_post(payload, @api_url, @verify_cert, @auth_token)
  end
end 

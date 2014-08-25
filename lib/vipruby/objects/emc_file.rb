require 'rest-client'
require 'json'

  # EMC VNX for File storage system support
  # => Supported Protocol: NFS, CIFS (Snapshot restore is not supported for Isilon storage systems.)
  # VNX File Control Station default port is 443
  # VNX File Onboard Storage Provider default port is 5988
class EMCfile

  def initialize (name, ip_address, port, user_name, password, 
    smis_provider_ip, smis_port, smis_user_name, smis_password, 
    smis_use_ssl, api_url, verify_cert, auth_token)

    @name = name
    @ip_address = ip_address
    @port = port
    @user_name = user_name
    @password = password
    @smis_provider_ip = smis_provider_ip
    @smis_port = smis_port
    @smis_user_name = smis_user_name
    @smis_password = smis_password
    @smis_use_ssl = smis_use_ssl
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

  def smis_provider_ip
  	@smis_provider_ip
  end

  def smis_port
    @smis_port
  end
  
  def smis_user_name
    @smis_user_name
  end

  def smis_password
    @smis_password
  end

  def smis_use_ssl
    @smis_use_ssl
  end

  def api_url
    @api_url
  end

  def add
    payload = {
      name: @name,
      system_type:  "vnxfile",
      ip_address: @ip_address,
      port_number: @port,
      user_name: @user_name,
      password: @password,
      smis_provider_ip: @smis_provider_ip
      smis_port_number: @smis_port_number
      smis_user_name: @smis_user_name
      smis_password: @smis_password
      smis_use_ssl: @smis_use_ssl 
    }.to_json

    RestCall.rest_post(payload, @api_url, @verify_cert, @auth_token)
  end
end 

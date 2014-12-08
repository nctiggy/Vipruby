require 'rest-client'
require 'json'

module ViprStorageProvider

	@smis_provider_api = "#{base_url}/vdc/smis-providers"
	@storage_providers_api = "#{base_url}/vdc/storage-providers"
	@storage_systems_api = "#{base_url}/vdc/storage-systems"

	# EMC VMAX and VNX for block storage system version support
	# => For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com)
	# The EMC SMI-S Provider (a component of EMC Solutions Enabler) is required to use VMAX storage or VNX block. 
	# The following information is required to verify & add the SMI-S provider storage systems to ViPR:
	# => SMI-S Provider host address
	# => SMI-S Provider credentials (default is admin/#1Password) 
	# => SMI-S Provider port (default is 5989)
	#
	# @param name [String] the name of the device
	# @param ip_address [string] the ip address of the device
	# @return [JSON] the object converted into the expected format.
	# @author Kendrick Coleman
	def add_emc_block(name=nil, ip_or_dns=nil, port=nil, user_name=nil, password=nil, use_ssl=nil, api_url=nil, auth=nil, cert=nil)
		check_emc_block_payload(name, ip_or_dns)

	    payload = {
	      name: name,
	      ip_address: ip_or_dns,
	      port_number: port.nil? ? '5989' : port,
	      user_name: user_name.nil? ? 'admin' : user_name,
	      password: password.nil? ? '#1Password' : password,
	      use_ssl: use_ssl.nil? ? false : use_ssl
	    }
	    rest_post(payload, api_url.nil? @smis_provider_api : api_url, auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end
=begin
  	# EMC VNX for File storage system support
    # => Supported Protocol: NFS, CIFS (Snapshot restore is not supported for Isilon storage systems.)
    # VNX File Control Station default port is 443
    # VNX File Onboard Storage Provider default port is 5988
    def add_emc_file(name, ip_address, port, user_name, password, smis_provider_ip, smis_port_number, smis_user_name, smis_password, smis_use_ssl)
        api_url = "#{base_url}/vdc/storage-systems"
        EMCfile.new(name, ip_address, port, user_name, password, smis_provider_ip, smis_port_number, smis_user_name, smis_password, smis_use_ssl, api_url, @verify_cert, @auth_token).add
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
=end
	#############################################################
    # Error Handling method to make sure params are there
    ##############################################################
    def check_emc_block_payload(name=nil, ip_or_dns=nil)
      if name == nil || ip_or_dns == nil
          raise "Missing Param 'name' or 'ip_or_dns'"
      end
    end

end
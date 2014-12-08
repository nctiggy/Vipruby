require 'rest-client'
require 'json'

module ViprStorageSystem

	def storage_provider_payload(name, interface_type, ip_or_dns, port, user_name, password, use_ssl)
		payload = {
	    	name: name,
	    	interface_type: interface_type,
	    	ip_address: ip_or_dns,
	    	port_number: port,
	    	user_name: user_name.nil? ? 'admin' : user_name,
	    	password: password.nil? ? '#1Password' : password,
	    	use_ssl: use_ssl.nil? ? false : use_ssl
	    }.to_json

	    return payload
	end

	def storage_system_payload(name, system_type, ip_or_dns, port, user_name, password, smis_provider_ip=nil, smis_port_number=nil, smis_user_name=nil, smis_password=nil, smis_use_ssl=nil)
		if smis_provider_ip == nil
			payload = {
		    	name: name,
		    	system_type: system_type,
		    	ip_address: ip_or_dns,
		    	port_number: port,
		    	user_name: user_name.nil? ? 'admin' : user_name,
		    	password: password.nil? ? '#1Password' : password,
		    }.to_json
	    else
	    	payload = {
	      		name: name,
	      		system_type: system_type,
	      		ip_address: ip_or_dns,
	      		port_number: port,
	      		user_name: user_name.nil? ? 'admin' : user_name,
	      		password: password.nil? ? '#1Password' : password,
	     		smis_provider_ip: smis_provider_ip,
			    smis_port_number: smis_port_number.nil? ? '5988' : smis_port_number,
			    smis_user_name: smis_user_name.nil? ? 'admin' : smis_user_name,
			    smis_password: smis_password.nil? ? '#1Password' : smis_password,
			    smis_use_ssl: smis_use_ssl.nil? ? false : smis_use_ssl
			 }.to_json
		end

	    return payload
	end

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
	def add_emc_block(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, auth=nil, cert=nil)
		check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '5989' : port = port
	    rest_post(storage_provider_payload(name, 'smis', ip_or_dns, port, user_name, password, use_ssl), "#{@base_url}/vdc/storage-providers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Hitachi Data Systems support
    # For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com).
    # Hitachi HiCommand Device Manager is required to use HDS storage with ViPR. 
    # You need to obtain the following information to configure and add the Hitachi HiCommand Device manager to ViPR:
    # => A host or virtual machine for HiCommand Device manager setup
    # => HiCommand Device Manager license, host address, credentials, and host port (default is 2001) 
    #
    # @param name [String] the name of the device
	# @param ip_address [string] the ip address of the device
	# @return [JSON] the object converted into the expected format.
	# @author Kendrick Coleman
    def add_hitachi(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, auth=nil, cert=nil)
    	check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '2001' : port = port
	    rest_post(storage_provider_payload(name, 'hicommand', ip_or_dns, port, user_name, password, use_ssl), "#{@base_url}/vdc/storage-providers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # ViPR configuration requirements for VPLEX storage systems
    # ViPR supports VPLEX in a Local or Metro configuration. VPLEX Geo configurations are not supported. 
    #
    # @param name [String] the name of the device
	# @param ip_address [string] the ip address of the device
	# @return [JSON] the object converted into the expected format.
	# @author Kendrick Coleman
    def add_vplex(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, auth=nil, cert=nil)
        check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '443' : port = port
	    rest_post(storage_provider_payload(name, 'vplex', ip_or_dns, port, user_name, password, use_ssl), "#{@base_url}/vdc/storage-providers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # Stand-alone ScaleIO support and preconfiguration requirements
    # Supported versions: ScaleIO 1.21.0.20 or later 
    # Preconfiguration requirements:
    # => Protection domains are defined.
    # => All storage pools are defined. 
    #
    # @param name [String] the name of the device
	# @param ip_address [string] the ip address of the device
	# @return [JSON] the object converted into the expected format.
	# @author Kendrick Coleman
    def add_scaleio(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, auth=nil, cert=nil)
        check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '22' : port = port
	    rest_post(storage_provider_payload(name, 'scaleio', ip_or_dns, port, user_name, password, use_ssl), "#{@base_url}/vdc/storage-providers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # Third-party block storage provider installation requirements
    # ViPR uses the OpenStack Block Storage (Cinder) Service to add third-party block storage systems to ViPR. 
    # For supported versions, see the EMC ViPR Support Matrix available on the EMC Community Network (community.emc.com). 
    #
    # @param name [String] the name of the device
	# @param ip_address [string] the ip address of the device
	# @return [JSON] the object converted into the expected format.
	# @author Kendrick Coleman
    def add_third_party_block(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, auth=nil, cert=nil)
        check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '22' : port = port
	    rest_post(storage_provider_payload(name, 'cinder', ip_or_dns, port, user_name, password, use_ssl), "#{@base_url}/vdc/storage-providers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # Isilon Storage System Support
    # => Supported Protocol: NFS, CIFS (Snapshot restore is not supported for Isilon storage systems.)
    # Port (default is 8080) 
    #
    # @param name [String] the name of the device
	# @param ip_address [string] the ip address of the device
	# @return [JSON] the object converted into the expected format.
	# @author Kendrick Coleman
    def add_isilon(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, auth=nil, cert=nil)
        check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '8080' : port = port
	    rest_post(storage_system_payload(name, 'isilon', ip_or_dns, port, user_name, password), "#{@base_url}/vdc/storage-systems", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

  	# EMC VNX for File storage system support
    # => Supported Protocol: NFS, CIFS (Snapshot restore is not supported for Isilon storage systems.)
    # VNX File Control Station default port is 443
    # VNX File Onboard Storage Provider default port is 5988
    #
    # @param name [String] the name of the device
	# @param ip_address [string] the ip address of the device
	# @return [JSON] the object converted into the expected format.
	# @author Kendrick Coleman
    def add_emc_file(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, smis_provider_ip=nil, smis_user_name=nil, smis_password=nil, smis_port_number=nil, smis_use_ssl=nil, auth=nil, cert=nil)
    	check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '443' : port = port
		smis_port_number.nil? ? smis_port_number = '5988' : smis_port_number = smis_port_number
	    rest_post(storage_system_payload(name, 'vnxfile', ip_or_dns, port, user_name, password, smis_provider_ip, smis_port_number, smis_user_name, smis_password, smis_use_ssl), "#{@base_url}/vdc/storage-systems", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # NetApp Storage System Support
    # => Supported Protocol: NFS, CIFS
    #
    # @param name [String] the name of the device
	# @param ip_address [string] the ip address of the device
	# @return [JSON] the object converted into the expected format.
	# @author Kendrick Coleman
    def add_netapp(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, auth=nil, cert=nil)
    	check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '443' : port = port
	    rest_post(storage_system_payload(name, 'netapp', ip_or_dns, port, user_name, password), "#{@base_url}/vdc/storage-systems", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end


	#############################################################
    # Error Handling method to make sure params are there
    ##############################################################
    def check_storage_provider_payload(name=nil, ip_or_dns=nil)
      if name == nil || ip_or_dns == nil
          raise "Missing Param 'name' or 'ip_or_dns'"
      end
    end

end
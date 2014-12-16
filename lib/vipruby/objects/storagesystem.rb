require 'rest-client'
require 'json'

# The Following Storage System calls will add Storage Systems for all tenants. these commands can only be ran as the root/default tenant
module ViprStorageSystem
	# JSON Structure for creating the payload for Storage Providers
	#
	# @param name [String] Name of the Storage Provider. This name is arbitrary and only exists within ViPR. This is a required string.
	# @param interface_type [String] Interface type of the Storage Provider. This generated automatically based on the method call for types of storage providers. This is a required string.
	# @param ip_or_dns [String] IP Address or FQDN of the Storage Provider. This is a required string.
  	# @param port [String] Port of the Storage Provider. This is a required string. This generated automatically based on the method call for types of storage providers. This is a required string. This can be modified based depending upon the storage system method call
  	# @param user_name [String] User Name that will be used for authenticating against the Storage Provider. This is a required string. If a User Name is not provided, then 'admin' is used
  	# @param password [String] Password for the user_name that will be used for authenticating against the Storage Provider. This is a required string. If a Password is not provided, then '#1Password' is used
  	# @param use_ssl [Boolean] Specify true or false for communicating to the Storage Provider. This is a required string, and will default to false unless 'true' is specified
  	# 
  	# @return [JSON] The JSON structure for the post operation
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

	# JSON Structure for creating the payload for Storage Providers
	#
	# @param name [String] Name of the Storage System. This name is arbitrary and only exists within ViPR. This is a required string.
  	# @param system_type [String] Interface type of the Storage System. This generated automatically based on the method call for types of storage providers. This is a required string.
  	# @param ip_or_dns [String] IP Address or FQDN of the Storage System. This is a required string.
  	# @param port [String] Port of the Storage System. This is a required string. This generated automatically based on the method call for types of storage providers. This is a required string. This can be modified based depending upon the storage system method call
  	# @param user_name [String] User Name that will be used for authenticating against the Storage System. This is a required string. If a User Name is not provided, then 'admin' is used
  	# @param password [String] Password for the user_name that will be used for authenticating against the Storage System. This is a required string. If a Password is not provided, then '#1Password' is used
  	# @param smis_provider_ip [String] IP Address or FQDN of the SMI-S Provider for the Storage System. This is a required string. Only used for {#add_emc_file} method
  	# @param smis_port_number [String] Port Number of the SMI-S Provider for the Storage System. This is a required string, and will default to '5988' unless something else is specified. Only used for {#add_emc_file} method
  	# @param smis_user_name [String] User Name that will be used for authenticating against the SMI-S Provider to the Storage System. This is a required string, and will default to 'admin' unless something else is specified. Only used for {#add_emc_file} method
  	# @param smis_password [String] Password that will be used for authenticating against the SMI-S Provider to the Storage System. This is a required string, and will default to '#1Password' unless something else is specified. Only used for {#add_emc_file} method
  	# @param smis_use_ssl [Boolean] Specify true or false for communicating to the Storage System. This is a required string, and will default to false unless true is passed. Only used for {#add_emc_file} method
  	#
  	# @return [JSON] The JSON structure for the post operation
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

	# Add EMC VMAX and VNX Block Storage System
	# @note For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com)
	#
	# @param name [String] Name of the EMC Block Device. This name is arbitrary and only exists within ViPR. This is a required string.
	# @param ip_or_dns [String] FQDN or IP Address of the EMC Block Device to add. This is a required string.
	# @param user_name [String] User Name that will be used for authenticating against the EMC Block Device. This is an optional string. If no parameter is passed, then 'admin' is used. If you wish to specify a different password, port, or use_ssl param set this to nil
	# @param password [String] Password that will be used for authenticating against the EMC Block Device. This is an optional string. If no parameter is passed, then '#1Password' is used. If you wish to specify a different username, port, or use_ssl param set this to nil
	# @param port [String] Port that will be used for communicating with the EMC Block Device. This is an optional string. If no parameter is passed, then '5989' is used. If you wish to specify a different user_name, password, or use_ssl param set this to nil
	# @param use_ssl [String] SSL setting for communicating with the EMC Block Device. This is an optional string. If no parameter is passed, then 'false' is used.
	#
	# @return [Hash] The resulted post operation
	#
	# @example Add EMC VMAX and VNX Block Storage System
	#   vipr.add_emc_block('vnx01', 'vnx01.mydomain.com')
	#   vipr.add_emc_block('vnx02', 'vnx02.mydomain.com', 'sysadmin', 'sysadmin')
	#   vipr.add_emc_block('vnx03', 'vnx03.mydomain.com', 'sysadmin', 'sysadmin', '8093', 'true')
	def add_emc_block(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, auth=nil, cert=nil)
		check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '5989' : port = port
	    rest_post(storage_provider_payload(name, 'smis', ip_or_dns, port, user_name, password, use_ssl), "#{@base_url}/vdc/storage-providers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Add Hitachi Storage Systems
	# @note For supported versions, see the EMC ViPR Support Matrix on the EMC Community Network (community.emc.com).
	# 	Hitachi HiCommand Device Manager is required to use HDS storage with ViPR.
	# 	You need to obtain the following information to configure and add the Hitachi HiCommand Device manager to ViPR:
	# 	(1) A host or virtual machine for HiCommand Device manager setup
	# 	(2) HiCommand Device Manager license, host address, credentials, and host port (default is 2001)
	#
	# @param name [String] Name of the Hitachi Device. This name is arbitrary and only exists within ViPR. This is a required string.
	# @param ip_or_dns [String] FQDN or IP Address of the Hitachi Device to add. This is a required string.
	# @param user_name [String] User Name that will be used for authenticating against the Hitachi Device. This is an optional string. If no parameter is passed, then 'admin' is used. If you wish to specify a different password, port, or use_ssl param set this to nil
	# @param password [String] Password that will be used for authenticating against the Hitachi Device. This is an optional string. If no parameter is passed, then '#1Password' is used. If you wish to specify a different username, port, or use_ssl param set this to nil
	# @param port [String] Port that will be used for communicating with the Hitachi Device. This is an optional string. If no parameter is passed, then '2001' is used. If you wish to specify a different user_name, password, or use_ssl param set this to nil
	# @param use_ssl [String] SSL setting for communicating with the Hitachi Device. This is an optional string. If no parameter is passed, then 'false' is used.
	#
	# @return [Hash] The resulted post operation
	#
	# @example Add Hitachi Storage System
	#   vipr.add_hitachi('hitachi01', 'hitachi01.mydomain.com')
	#   vipr.add_hitachi('hitachi02', 'hitachi02.mydomain.com', 'sysadmin', 'sysadmin')
	#   vipr.add_hitachi('hitachi03', 'hitachi03.mydomain.com', 'sysadmin', 'sysadmin', '8093', 'true')
    def add_hitachi(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, auth=nil, cert=nil)
    	check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '2001' : port = port
	    rest_post(storage_provider_payload(name, 'hicommand', ip_or_dns, port, user_name, password, use_ssl), "#{@base_url}/vdc/storage-providers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

	# Add VPLEX Storage Systems
	# @note ViPR supports VPLEX in a Local or Metro configuration. VPLEX Geo configurations are not supported. 
	#
	# @param name [String] Name of the VPLEX Device. This name is arbitrary and only exists within ViPR. This is a required string.
	# @param ip_or_dns [String] FQDN or IP Address of the VPLEX Device to add. This is a required string.
	# @param user_name [String] User Name that will be used for authenticating against the VPLEX Device. This is an optional string. If no parameter is passed, then 'admin' is used. If you wish to specify a different password, port, or use_ssl param set this to nil
	# @param password [String] Password that will be used for authenticating against the VPLEX Device. This is an optional string. If no parameter is passed, then '#1Password' is used. If you wish to specify a different username, port, or use_ssl param set this to nil
	# @param port [String] Port that will be used for communicating with the VPLEX Device. This is an optional string. If no parameter is passed, then '443' is used. If you wish to specify a different user_name, password, or use_ssl param set this to nil
	# @param use_ssl [String] SSL setting for communicating with the VPLEX Device. This is an optional string. If no parameter is passed, then 'false' is used.
	#
	# @return [Hash] The resulted post operation
	#
	# @example Add VPLEX Storage System
	#   vipr.add_vplex('VPLEX01', 'VPLEX01.mydomain.com')
	#   vipr.add_vplex('VPLEX02', 'VPLEX02.mydomain.com', 'sysadmin', 'sysadmin')
	#   vipr.add_vplex('VPLEX03', 'VPLEX03.mydomain.com', 'sysadmin', 'sysadmin', '8093', 'true')
    def add_vplex(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, auth=nil, cert=nil)
        check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '443' : port = port
	    rest_post(storage_provider_payload(name, 'vplex', ip_or_dns, port, user_name, password, use_ssl), "#{@base_url}/vdc/storage-providers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

	# Add ScaleIO Storage Systems
	# @note Supported versions: ScaleIO 1.21.0.20 or later. 
	# 	Preconfiguration requirements:
	# 	(1) Protection domains are defined.
	# 	(2) All storage pools are defined. 
	# 
	# @param name [String] Name of the ScaleIO Storage System. This name is arbitrary and only exists within ViPR. This is a required string.
	# @param ip_or_dns [String] FQDN or IP Address of the ScaleIO Storage System to add. This is a required string.
	# @param user_name [String] User Name that will be used for authenticating against the ScaleIO Storage System. This is an optional string. If no parameter is passed, then 'admin' is used. If you wish to specify a different password, port, or use_ssl param set this to nil
	# @param password [String] Password that will be used for authenticating against the ScaleIO Storage System. This is an optional string. If no parameter is passed, then '#1Password' is used. If you wish to specify a different username, port, or use_ssl param set this to nil
	# @param port [String] Port that will be used for communicating with the ScaleIO Storage System. This is an optional string. If no parameter is passed, then '22' is used. If you wish to specify a different user_name, password, or use_ssl param set this to nil
	# @param use_ssl [String] SSL setting for communicating with the ScaleIO Storage System. This is an optional string. If no parameter is passed, then 'false' is used.
	#
	# @return [Hash] The resulted post operation
	#
	# @example Add ScaleIO Storage System
	#   vipr.add_scaleio('scaleio01', 'scaleio01.mydomain.com')
	#   vipr.add_scaleio('scaleio02', 'scaleio02.mydomain.com', 'sysadmin', 'sysadmin')
	#   vipr.add_scaleio('scaleio03', 'scaleio03.mydomain.com', 'sysadmin', 'sysadmin', '8093', 'true')
    def add_scaleio(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, auth=nil, cert=nil)
        check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '22' : port = port
	    rest_post(storage_provider_payload(name, 'scaleio', ip_or_dns, port, user_name, password, use_ssl), "#{@base_url}/vdc/storage-providers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # Add Third Party Block Storage Provider
    # @note ViPR uses the OpenStack Block Storage (Cinder) Service to add third-party block storage systems to ViPR. 
    # 	For supported versions, see the EMC ViPR Support Matrix available on the EMC Community Network (community.emc.com).
    #
    # @param name [String] Name of the Third Party Block Storage Provider. This name is arbitrary and only exists within ViPR. This is a required string.
    # @param ip_or_dns [String] FQDN or IP Address of the Third Party Block Storage Provider to add. This is a required string.
    # @param user_name [String] User Name that will be used for authenticating against the Third Party Block Storage Provider. This is an optional string. If no parameter is passed, then 'admin' is used. If you wish to specify a different password, port, or use_ssl param set this to nil
    # @param password [String] Password that will be used for authenticating against the Third Party Block Storage Provider. This is an optional string. If no parameter is passed, then '#1Password' is used. If you wish to specify a different username, port, or use_ssl param set this to nil
    # @param port [String] Port that will be used for communicating with the Third Party Block Storage Provider. This is an optional string. If no parameter is passed, then '22' is used. If you wish to specify a different user_name, password, or use_ssl param set this to nil
    # @param use_ssl [String] SSL setting for communicating with the Third Party Block Storage Provider. This is an optional string. If no parameter is passed, then 'false' is used.
    #
    # @return [Hash] The resulted post operation
    #
    # @example Add Third Party Block Storage Provider
    #   vipr.add_third_party_block('cinder01', 'cinder01.mydomain.com')
    #   vipr.add_third_party_block('cinder01', 'cinder01.mydomain.com', 'sysadmin', 'sysadmin')
    #   vipr.add_third_party_block('cinder01', 'cinder01.mydomain.com', 'sysadmin', 'sysadmin', '8093', 'true')
    def add_third_party_block(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, use_ssl=nil, auth=nil, cert=nil)
        check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '22' : port = port
	    rest_post(storage_provider_payload(name, 'cinder', ip_or_dns, port, user_name, password, use_ssl), "#{@base_url}/vdc/storage-providers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # Add Isilon Storage Provider
    # @note Supported Protocol: NFS, CIFS (Snapshot restore is not supported for Isilon storage systems.).
    # 	Port (default is 8080) 
    #
    # @param name [String] Name of the Isilon Storage Provider. This name is arbitrary and only exists within ViPR. This is a required string.
    # @param ip_or_dns [String] FQDN or IP Address of the Isilon Storage Provider to add. This is a required string.
    # @param user_name [String] User Name that will be used for authenticating against the Isilon Storage Provider. This is an optional string. If no parameter is passed, then 'admin' is used. If you wish to specify a different password, port, or use_ssl param set this to nil
    # @param password [String] Password that will be used for authenticating against the Isilon Storage Provider. This is an optional string. If no parameter is passed, then '#1Password' is used. If you wish to specify a different username, port, or use_ssl param set this to nil
    # @param port [String] Port that will be used for communicating with the Isilon Storage Provider. This is an optional string. If no parameter is passed, then '8080' is used. If you wish to specify a different user_name, password, or use_ssl param set this to nil
    #
    # @return [Hash] The resulted post operation
    #
    # @example Add Isilon Storage Provider
    #   vipr.add_isilon('isilon01', 'isilon01.mydomain.com')
    #   vipr.add_isilon('isilon01', 'isilon01.mydomain.com', 'sysadmin', 'sysadmin')
    #   vipr.add_isilon('isilon01', 'isilon01.mydomain.com', 'sysadmin', 'sysadmin', '8093')
    def add_isilon(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, auth=nil, cert=nil)
        check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '8080' : port = port
	    rest_post(storage_system_payload(name, 'isilon', ip_or_dns, port, user_name, password), "#{@base_url}/vdc/storage-systems", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # Add EMC VNX for File Storage Provider
    # @note VNX File Control Station default port is 443. VNX File Onboard Storage Provider default port is 5988
    #
    # @param name [String] Name of the EMC VNX for File Storage Provider. This name is arbitrary and only exists within ViPR. This is a required string.
    # @param ip_or_dns [String] FQDN or IP Address of the EMC VNX for File Storage Provider to add. This is a required string.
    # @param user_name [String] User Name that will be used for authenticating against the EMC VNX for File Storage Provider. This is an optional string. If no parameter is passed, then 'admin' is used. If you wish to specify a different password, port, or use_ssl param set this to nil
    # @param password [String] Password that will be used for authenticating against the EMC VNX for File Storage Provider. This is an optional string. If no parameter is passed, then '#1Password' is used. If you wish to specify a different username, port, or use_ssl param set this to nil
    # @param port [String] Port that will be used for communicating with the EMC VNX for File Storage Provider. This is an optional string. If no parameter is passed, then '443' is used. If you wish to specify a different user_name, password, or use_ssl param set this to nil
    # @param smis_provider_ip [String] IP Address for the SMI-S Communicator for the EMC VNX for File Storage Provider. This is a required string.
    # @param smis_user_name [String] User Name for the SMI-S Communicator for the EMC VNX for File Storage Provider. This is an optional string. If no parameter is passed, then 'admin' is used.
    # @param smis_password [String] Password for the user_name for the SMI-S Communicator for the EMC VNX for File Storage Provider.  This is an optional string. If no parameter is passed, then '#1Password' is used.
    # @param smis_port_number [String] Port Number for the SMI-S Communicator for the EMC VNX for File Storage Provider.  This is an optional string. If no parameter is passed, then '5988' is used.
    # @param smis_use_ssl [String] SSL setting for communicating with the SMI-S Communicator for the EMC VNX for File Storage Provider.  This is an optional string. If no parameter is passed, then 'false' is used.
    #
    # @return [Hash] The resulted post operation
    #
    # @example Add EMC VNX for File Storage Provider
    #   vipr.add_emc_file('vnx01', 'vnx01.mydomain.com', 'sysadmin', 'sysadmin', nil, 'smi_s_ip', 'smi_s_un', 'smi_s_pw')
    #   vipr.add_emc_file('vnx01', 'vnx01.mydomain.com', 'sysadmin', 'sysadmin', '1067', 'smi_s_ip', 'smi_s_un', 'smi_s_pw', '1068', 'true')
    def add_emc_file(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, smis_provider_ip=nil, smis_user_name=nil, smis_password=nil, smis_port_number=nil, smis_use_ssl=nil, auth=nil, cert=nil)
    	check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '443' : port = port
		smis_port_number.nil? ? smis_port_number = '5988' : smis_port_number = smis_port_number
	    rest_post(storage_system_payload(name, 'vnxfile', ip_or_dns, port, user_name, password, smis_provider_ip, smis_port_number, smis_user_name, smis_password, smis_use_ssl), "#{@base_url}/vdc/storage-systems", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end

    # Add NetApp Storage Provider
    # @note Supported Protocol: NFS, CIFS
    # 	For supported versions, see the EMC ViPR Support Matrix available on the EMC Community Network (community.emc.com).
    #
    # @param name [String] Name of the NetApp Storage Provider. This name is arbitrary and only exists within ViPR. This is a required string.
    # @param ip_or_dns [String] FQDN or IP Address of the NetApp Storage Provider to add. This is a required string.
    # @param user_name [String] User Name that will be used for authenticating against the NetApp Storage Provider. This is an optional string. If no parameter is passed, then 'admin' is used. If you wish to specify a different password, port, or use_ssl param set this to nil
    # @param password [String] Password that will be used for authenticating against the NetApp Storage Provider. This is an optional string. If no parameter is passed, then '#1Password' is used. If you wish to specify a different username, port, or use_ssl param set this to nil
    # @param port [String] Port that will be used for communicating with the NetApp Storage Provider. This is an optional string. If no parameter is passed, then '443' is used. If you wish to specify a different user_name, password, or use_ssl param set this to nil
    #
    # @return [Hash] The resulted post operation
    #
    # @example Add NetApp Storage Provider
    #   vipr.netapp('netapp01', 'netapp01.mydomain.com')
    #   vipr.netapp('netapp01', 'netapp01.mydomain.com', 'sysadmin', 'sysadmin')
    #   vipr.netapp('netapp01', 'netapp01.mydomain.com', 'sysadmin', 'sysadmin', '8093')
    def add_netapp(name=nil, ip_or_dns=nil, user_name=nil, password=nil, port=nil, auth=nil, cert=nil)
    	check_storage_provider_payload(name, ip_or_dns)
		port.nil? ? port = '443' : port = port
	    rest_post(storage_system_payload(name, 'netapp', ip_or_dns, port, user_name, password), "#{@base_url}/vdc/storage-systems", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
    end


 	private

 	# Error Handling method to check for Missing Param. If the pass fails, an error exception is raised
 	#
 	# @param name [String] Name of the Storage Provider. This name is arbitrary and only exists within ViPR. This is a required string.
 	# @param ip_or_dns [String] FQDN or IP Address of the Storage Provider to add. This is a required string.
 	#
 	# @return [Boolean] True if passes. If fails, raise exception
    def check_storage_provider_payload(name=nil, ip_or_dns=nil)
      if name == nil || ip_or_dns == nil
          raise "Missing Param 'name' or 'ip_or_dns'"
      end
    end

end
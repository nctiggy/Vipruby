require 'json'

# The following VirtualDataCenter calls will get and execute VirtualDataCenter items
module ViprVirtualDataCenter
	# Get All VirtualDataCenters
	#
	# @return [json] JSON object of all the VirtualDataCenters
	def get_vdcs(auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualDataCenter information
	#
	# @param vdc_id [urn:id] URN of a VirtualDatacenter. Required Param
	#
	# @return [JSON] The JSON object of the VirtualDataCenter
	def get_vdc(vdc_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/#{vdc_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualDataCenter Secret-Key
	#
	# @return [JSON] The JSON object of the VirtualDataCenter Secret-Key
	def get_vdc_secretkey(auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/secret-key", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

end
require 'json'

# The following Virtual Array calls will get and execute virtual array items
module ViprVirtualArray
	# Search VirtualArrays
	#
	# @return [json] JSON object of all the VirtualArrays in zone
	def search_varrays(auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays/search", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get/List VirtualArrays in zone
	#
	# @return [json] JSON object of all the VirtualArrays in zone
	def get_varrays(auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualArray information
	#
	# @param varray [urn:id] URN of a VirtualArray. Required Param
	#
	# @return [JSON] The JSON object of the VirtualArray
	def get_varray(varray_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays/#{varray_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualArray Auto-Tier Policy
	#
	# @param varray [urn:id] URN of a VirtualArray. Required Param
	#
	# @return [JSON] The JSON object of the VirtualArray Auto-Tier Policy
	def get_varray_autotier_policy(varray_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays/#{varray_id}/auto-tier-policies", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualArray Storage Pools
	#
	# @param varray [urn:id] URN of a VirtualArray. Required Param
	#
	# @return [JSON] The JSON object of the VirtualArray Storage Pools
	def get_varray_storage_pools(varray_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays/#{varray_id}/storage-pools", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualArray Storage Ports
	#
	# @param varray [urn:id] URN of a VirtualArray. Required Param
	#
	# @return [JSON] The JSON object of the VirtualArray Storage Ports
	def get_varray_storage_ports(varray_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays/#{varray_id}/storage-ports", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualArray Virtual Pools
	#
	# @param varray [urn:id] URN of a VirtualArray. Required Param
	#
	# @return [JSON] The JSON object of the VirtualArray Virtual Pools
	def get_varray_virtual_pools(varray_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays/#{varray_id}/vpools", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualArray Networks
	#
	# @param varray [urn:id] URN of a VirtualArray. Required Param
	#
	# @return [JSON] The JSON object of the VirtualArray Networks
	def get_varray_networks(varray_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays/#{varray_id}/networks", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualArray ACL
	#
	# @param varray [urn:id] URN of a VirtualArray. Required Param
	#
	# @return [JSON] The JSON object of the VirtualArray ACL
	def get_varray_acl(varray_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays/#{varray_id}/acl", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualArray Connectivity
	#
	# @param varray [urn:id] URN of a VirtualArray. Required Param
	#
	# @return [JSON] The JSON object of the VirtualArray Connectivity
	def get_varray_connectivity(varray_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays/#{varray_id}/connectivity", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single VirtualArray available attributes
	#
	# @param varray [urn:id] URN of a VirtualArray. Required Param
	#
	# @return [JSON] The JSON object of the VirtualArray available attributes
	def get_varray_attributes(varray_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/varrays/#{varray_id}/available-attributes", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

end
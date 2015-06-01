require 'json'

# The following Tenant calls will get and execute tenant items
module ViprTenant
	# Get tenants
	#
	# @return [json] JSON object of all the tenants in URN forman
	def get_tenants(auth=nil, cert=nil)
		rest_get("#{@base_url}/tenants/bulk", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single tenant information
	#
	# @param tenant_id [urn:id] URN of a tenant. Required Param
	#
	# @return [JSON] The JSON object of the tenant
	def get_tenant(tenant_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/tenants/#{tenant_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single tenant subtenants information
	#
	# @param tenant_id [urn:id] URN of a tenant. Required Param
	#
	# @return [JSON] The JSON object of all subtenants of a tenant
	def get_subtenants(tenant_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/tenants/#{tenant_id}/subtenants", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single tenant projects information
	#
	# @param tenant_id [urn:id] URN of a tenant. Required Param
	#
	# @return [JSON] The JSON object of all projects of a tenant
	def get_tenant_projects(tenant_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/tenants/#{tenant_id}/projects", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

end
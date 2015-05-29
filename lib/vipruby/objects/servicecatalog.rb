require 'json'

# The following Servce Catalog calls will get and execute service catalog items
module ViprServiceCatalog
	# Get root category
	#
	# @return [json] JSON object of all the root children categories 
	def get_sc_category_root(auth=nil, cert=nil)
		rest_get("#{@base_url}/catalog/categories", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get all child categories of a category in ViPR
	#
	# @param cat_id [urn:id] URN of a category. Required Param
	#
	# @return [JSON] The JSON object of all children categories
	def get_sc_category_categories(cat_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/catalog/categories/#{cat_id}/categories", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get all child services of a category in ViPR
	#
	# @param cat_id [urn:id] URN of a category. Required Param
	#
	# @return [JSON] The JSON object of all children services
	def get_sc_category_categories_services(cat_id,auth=nil,cert=nil)
		rest_get("#{base_url}/catalog/categories/#{cat_id}/services", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get all services
	#
	# @return [JSON] The JSON object of all services
	def get_all_sc_services(auth=nil,cert=nil)
		rest_get("#{base_url}/catalog/services/bulk", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get Service Information
	#
	# @param service_id [urn:id] URN of a service. Required Param
	#
	# @return [JSON] The JSON object of all services
	def get_sc_service(service_id, auth=nil,cert=nil)
		rest_get("#{base_url}/catalog/services/#{service_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Build a Service Catalog Order JSON object
	#
	# @param tenant_id [urn:id] URN of the tenant to create the catalog service. Required Param
	# @param service_urn [urn:id] URN of the service to be executed. Required Param
	# @param parameters [json] JSON collection of parameters. Required Param
	#
	# @return [json] JSON object with details of the service executed
	#
	# @example
    #   x = vipr.get_tenants
    #   xid = vipr.get_tenant(id['id'][0])
    #   vipr.order_service(xid, "urn:theServiceYouWantToExecute", {"label" => "All", "friendly" => "Of"}, {"label" => "The", "friendly" => "Required"}, {"label" => "Params", "friendly" => "GotIt?"})
	def order_service(tenant_id, service_urn, *args)
		payload = {
            tenantId: tenant_id,
            parameters: args,
            catalog_service: service_urn
        }.to_json
        
        post_order_service(payload)
	end
	
	private
	# POST A Service Catalog Order
	#
	# @param payload [json] JSON collection of parameters that will come from order_service. Required Param
	#
	# @return [json] JSON object with details of the service executed
	def post_order_service(payload, auth=nil,cert=nil)
		rest_post(payload, "#{base_url}/catalog/orders", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end
end
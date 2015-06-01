require 'json'

# The following Storage Tier calls will get and execute Storage Tier items
module ViprStorageTier
	# Get Storage Tiers
	#
	# @return [json] JSON object of all the Storage Tiers
	def get_storage_tiers(auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/storage-tiers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get Single Storage Tier information
	#
	# @param storage_tier_id [urn:id] URN of a storage tier. Required Param
	#
	# @return [JSON] The JSON object of the Storage Tier
	def get_storage_tier(storage_tier_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/#{storage_tier_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

end
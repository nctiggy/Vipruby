require 'json'

# The following Auto Tier calls will get and execute Auto Tier items
module ViprAutoTier
	# Get All Auto Tier Policies
	#
	# @return [json] JSON object of all the Auto Tier Policies
	def get_auto_tier_policies(auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/auto-tier-policies", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get Single Auto Tier Policy information
	#
	# @param auto_tier_policy_id [urn:id] URN of a auto tier policy. Required Param
	#
	# @return [JSON] The JSON object of the Auto Tier Policy
	def get_auto_tier_policy(auto_tier_policy_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/#{auto_tier_policy_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# List storage tiers for auto tiering policy
	#
	# @param auto_tier_policy_id [urn:id] URN of a auto tier policy. Required Param
	#
	# @return [JSON] The JSON object of the storage tiers for auto tiering policy
	def get_auto_tier_policy_storage_tiers(auto_tier_policy_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/#{auto_tier_policy_id}/storage-tiers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

end
require 'json'

# The following Block Virtual Pool calls will get and execute Block Virtual Pool items
module ViprBlockVirtualPool
	# Get All Block Virtual Pools
	#
	# @return [json] JSON object of all the Block Virtual Pools
	def get_block_vpools(auth=nil, cert=nil)
		rest_get("#{@base_url}/block/vpools", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get Single Block Virtual Pool information
	#
	# @param block_vpool_id [urn:id] URN of a Block Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the Block Virtual Pool
	def get_block_vpool(block_vpool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/block/vpools/#{block_vpool_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get Single Block Virtual Pool ACL information
	#
	# @param block_vpool_id [urn:id] URN of a Block Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the Block Virtual Pool ACL
	def get_block_vpool_acl(block_vpool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/block/vpools/#{block_vpool_id}/acl", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get Single Block Virtual Pool Storage Pools information
	#
	# @param block_vpool_id [urn:id] URN of a Block Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the Block Virtual Pool Storage Pools
	def get_block_vpool_storage_pools(block_vpool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/block/vpools/#{block_vpool_id}/storage-pools", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Regresh Single Block Virtual Pool Matched Pools information
	#
	# @param block_vpool_id [urn:id] URN of a Block Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the Block Virtual Pool Storage Pools
	def get_block_vpool_refresh_matched_pools(block_vpool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/block/vpools/#{block_vpool_id}/refresh-matched-pools", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get Single Block Virtual Pool ACL information
	#
	# @param block_vpool_id [urn:id] URN of a Block Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the Block Virtual Pool ACL
	def get_block_vpool_acl(block_vpool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/block/vpools/#{block_vpool_id}/acl", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Deactivate Block Virtual Pool. Deactivate block store virtual pool, this will move the virtual pool to a "marked-for-deletion" state, and no more resource may be created using it. The virtual pool will be deleted when all references to this virtual pool of type Volume are deleted
	#
	# @param block_vpool_id [urn:id] URN of a Block Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the Block Virtual Pool
	def block_vpool_deactivate(block_vpool_id=nil,auth=nil, cert=nil)
		check_block_vpool_id_post(block_vpool_id)
	    payload = {
	        id: block_vpool_id
	      }.to_json
	    rest_post(payload, "#{@base_url}/block/vpools/#{block_vpool_id}/deactivate", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	private 
	# Error Handling method to check for Block Virtual Pool ID param. If the pass fails, an error exception is raised
	#
	# @param block_vpool_id [String] Requires the string of the block_vpool_id uid
	# @return [Boolean] True if pass, false if it fails
	#
	# @private
	def check_block_vpool_id_post(block_vpool_id=nil)
	  if block_vpool_id == nil
	      raise "Missing param (block_vpool_id)"
	  end
	end

end
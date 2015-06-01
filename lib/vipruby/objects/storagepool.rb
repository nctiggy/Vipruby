require 'json'

# The following StoragePool calls will get and execute StoragePool items
module ViprStoragePool
	# Get All StoragePools
	#
	# @return [json] JSON object of all the StoragePools
	def get_storage_pools(auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/storage-pools", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single StoragePool information
	#
	# @param storage_pool_id [urn:id] URN of a StoragePool. Required Param
	#
	# @return [JSON] The JSON object of the StoragePool
	def get_storage_pool(storage_pool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/storage-pools/#{storage_pool_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single StoragePool Storage-Tiers information
	#
	# @param storage_pool_id [urn:id] URN of a StoragePool. Required Param
	#
	# @return [JSON] The JSON object of the StoragePool Storage-Tiers
	def get_storage_pool_storage_tiers(storage_pool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/storage-pools/#{storage_pool_id}/storage-tiers", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single StoragePool Resources information
	#
	# @param storage_pool_id [urn:id] URN of a StoragePool. Required Param
	#
	# @return [JSON] The JSON object of the StoragePool Resources
	def get_storage_pool_resources(storage_pool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/storage-pools/#{storage_pool_id}/resources", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Deregister StoragePool. Allows the user to deregister a registered storage pool so that it is no longer used by the system. This simply sets the registration_status of the storage pool to UNREGISTERED
	#
	# @param storage_pool_id [urn:id] URN of a StoragePool. Required Param
	#
	# @return [JSON] The JSON object of the StoragePool
	def storage_pool_deregister(storage_pool_id=nil,auth=nil, cert=nil)
		check_storage_pool_id_post(storage_pool_id)
	    payload = {
	        id: storage_pool_id
	      }.to_json
	    rest_post(payload, "#{@base_url}/vdc/storage-pools/#{storage_pool_id}/deregister", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Deactivate StoragePool. Remove a storage pool. The method would remove the deregistered storage pool and all resources associated with the storage pool from the database. Note they are not removed from the storage system physically, but become unavailable for the user.
	#
	# @param storage_pool_id [urn:id] URN of a StoragePool. Required Param
	#
	# @return [JSON] The JSON object of the StoragePool
	def storage_pool_deactivate(storage_pool_id=nil,auth=nil, cert=nil)
		check_storage_pool_id_post(storage_pool_id)
	    payload = {
	        id: storage_pool_id
	      }.to_json
	    rest_post(payload, "#{@base_url}/vdc/storage-pools/#{storage_pool_id}/deactivate", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end


	private 
	# Error Handling method to check for Missing Storage Pool ID param. If the pass fails, an error exception is raised
	#
	# @param storage_pool_id [String] Requires the string of the storage_pool_id uid
	# @return [Boolean] True if pass, false if it fails
	#
	# @private
	def check_storage_pool_id_post(storage_pool_id=nil)
	  if storage_pool_id == nil
	      raise "Missing param (storage_pool_id)"
	  end
	end


end
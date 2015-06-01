require 'json'

# The following StoragePort calls will get and execute StoragePort items
module ViprStoragePort
	# Get All StoragePorts
	#
	# @return [json] JSON object of all the StoragePorts
	def get_storage_ports(auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/storage-ports", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get single StoragePort information
	#
	# @param storage_port_id [urn:id] URN of a StoragePort. Required Param
	#
	# @return [JSON] The JSON object of the StoragePort
	def get_storage_port(storage_port_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/vdc/storage-ports/#{storage_port_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Deregister StoragePort. Allows the user to deregister a registered storage port so that it is no longer used by the system. This simply sets the registration_status of the storage port to UNREGISTERED
	#
	# @param storage_port_id [urn:id] URN of a StoragePort. Required Param
	#
	# @return [JSON] The JSON object of the StoragePort
	def storage_port_deregister(storage_port_id=nil,auth=nil, cert=nil)
		check_storage_port_id_post(storage_port_id)
	    payload = {
	        id: storage_port_id
	      }.to_json
	    rest_post(payload, "#{@base_url}/vdc/storage-ports/#{storage_port_id}/deregister", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Deactivate StoragePort. Remove a storage port. The method would remove the deregistered storage port and all resources associated with the storage port from the database. Note they are not removed from the storage system physically, but become unavailable for the user.
	#
	# @param storage_port_id [urn:id] URN of a StoragePort. Required Param
	#
	# @return [JSON] The JSON object of the StoragePort
	def storage_port_deactivate(storage_port_id=nil,auth=nil, cert=nil)
		check_storage_port_id_post(storage_port_id)
	    payload = {
	        id: storage_port_id
	      }.to_json
	    rest_post(payload, "#{@base_url}/vdc/storage-ports/#{storage_port_id}/deactivate", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end


	private 
	# Error Handling method to check for Missing Storage Port ID param. If the pass fails, an error exception is raised
	#
	# @param storage_port_id [String] Requires the string of the storage_port_id uid
	# @return [Boolean] True if pass, false if it fails
	#
	# @private
	def check_storage_port_id_post(storage_port_id=nil)
	  if storage_port_id == nil
	      raise "Missing param (storage_port_id)"
	  end
	end


end
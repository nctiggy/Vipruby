require 'json'

# The following File Virtual Pool calls will get and execute File Virtual Pool items
module ViprFileVirtualPool
	# Get All File Virtual Pools
	#
	# @return [json] JSON object of all the File Virtual Pools
	def get_file_vpools(auth=nil, cert=nil)
		rest_get("#{@base_url}/file/vpools", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get Single File Virtual Pool information
	#
	# @param file_vpool_id [urn:id] URN of a File Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the File Virtual Pool
	def get_file_vpool(file_vpool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/file/vpools/#{file_vpool_id}", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get Single File Virtual Pool ACL information
	#
	# @param file_vpool_id [urn:id] URN of a File Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the File Virtual Pool ACL
	def get_file_vpool_acl(file_vpool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/file/vpools/#{file_vpool_id}/acl", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Get Single File Virtual Pool Storage Pools information
	#
	# @param file_vpool_id [urn:id] URN of a File Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the File Virtual Pool Storage Pools
	def get_file_vpool_storage_pools(file_vpool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/file/vpools/#{file_vpool_id}/storage-pools", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Regresh Single File Virtual Pool Matched Pools information
	#
	# @param file_vpool_id [urn:id] URN of a File Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the File Virtual Pool Storage Pools
	def get_file_vpool_refresh_matched_pools(file_vpool_id,auth=nil, cert=nil)
		rest_get("#{@base_url}/file/vpools/#{file_vpool_id}/refresh-matched-pools", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	# Deactivate File Virtual Pool. Deactivate file store virtual pool, this will move the virtual pool to a "marked-for-deletion" state, and no more resource may be created using it. The virtual pool will be deleted when all references to this virtual pool of type Volume are deleted
	#
	# @param file_vpool_id [urn:id] URN of a File Virtual Pool. Required Param
	#
	# @return [JSON] The JSON object of the File Virtual Pool
	def file_vpool_deactivate(file_vpool_id=nil,auth=nil, cert=nil)
		check_file_vpool_id_post(file_vpool_id)
	    payload = {
	        id: file_vpool_id
	      }.to_json
	    rest_post(payload, "#{@base_url}/file/vpools/#{file_vpool_id}/deactivate", auth.nil? ? @auth_token : auth, cert.nil? ? @verify_cert : cert)
	end

	private 
	# Error Handling method to check for File Virtual Pool ID param. If the pass fails, an error exception is raised
	#
	# @param file_vpool_id [String] Requires the string of the file_vpool_id uid
	# @return [Boolean] True if pass, false if it fails
	#
	# @private
	def check_file_vpool_id_post(file_vpool_id=nil)
	  if file_vpool_id == nil
	      raise "Missing param (file_vpool_id)"
	  end
	end

end